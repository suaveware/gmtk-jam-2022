extends Spatial

signal player_won
signal level_deloaded

export var tile_size = 2

var positions := {}
var player_grid_position := Vector2.ZERO

var tile = preload("res://src/Tile/Tile.tscn")

onready var player_mesh := $"../Player/Pivot/Rotator/Mesh"
onready var player = $"../Player"

onready var tutorial_label = $"../CanvasLayer/Gui/TutorialText"


func load_level(level = null):
	var position_sum: = Vector3.ZERO

	owner.game_state = owner.PRE_GAME
	player.reset()
	for child in get_children():
		positions = {}
		if(!child is Tween):
			child.queue_free()

	for tile in level.Tiles:
		position_sum += tile
		instantiate_tile(tile.x, tile.y, tile.z)

	# Position camera in the center
	var tiles_position_average: Vector3 = position_sum / level.Tiles.size()
	translation.x = -tiles_position_average.x - 1
	translation.z = -tiles_position_average.y - 1

	player_grid_position = level.StartPosition
	player.translation = Vector3(level.StartPosition.x* tile_size,15,level.StartPosition.y* tile_size) + translation

	var player_fall_delay: = ((level.LevelSize.x + level.LevelSize.y) as float) / 20
	$Tween.interpolate_property(
		player,
		'translation:y',
		12, 1, 0.65,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT,
		player_fall_delay
	)
	if(level.shouldFillGrid):
		for i in range(0, level.LevelSize.x):
			for j in range(0, level.LevelSize.y):
				if(!positions.get(Vector2(i, j))):
					instantiate_tile(i, j, rand_range(0,7))
	tutorial_label.text = level.tutorial
	$Tween.start()
	yield(get_tree().create_timer(player_fall_delay + 0.3), "timeout")
	AudioManager.sfx("FullRoll")

func deload_level():
	for pos in positions.keys():
		var tile = positions[pos]
		$Tween.interpolate_property(
			tile,
			'translation:y',
			0, -30, 0.5,
			Tween.TRANS_CUBIC,
			Tween.EASE_IN,
			((pos.x + pos.y) as float) / 20)
	$Tween.interpolate_property(
		player,
		'translation:y',
		1, 30, 0.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("level_deloaded")	

func instantiate_tile(x: int, y: int, value: int):
	var new_tile = tile.instance()
	new_tile.value = value
	call_deferred("add_child", new_tile)
	new_tile.translation = (Vector3(x, 20, y) * tile_size)
	positions[Vector2(x, y)] = new_tile
	$Tween.interpolate_property(
		new_tile,
		'translation:y',
		-12, 0, 1.2,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT,
		((x + y) as float) / 20)


func _on_Player_moved(direction: Vector3) -> void:
	match direction:
		Vector3.FORWARD:
			player_grid_position.y -= 1

		Vector3.BACK:
			player_grid_position.y += 1

		Vector3.RIGHT:
			player_grid_position.x += 1

		Vector3.LEFT:
			player_grid_position.x -= 1

	run_tile_effect()

	if player.has_good_faces():
		emit_signal("player_won")


func run_tile_effect() -> void:
	var tile = positions[player_grid_position]
	var facing_down_direction: Position3D = get_facing_down_direction()
	var current_face_value = player.face_values[facing_down_direction.name]

	if current_face_value > 0 and tile.value == tile.Type.UNGLUE:
		tile.value = 0
		tile.get_node("Thrashcan").hide()
		player.clear_face(facing_down_direction.name)
		return

	var dots = tile.get_node('dots')
	var is_empty = dots.get_children().size() == 0

	if is_empty:
		return

	for child in dots.get_children():
		var g_transform = child.global_transform
		dots.remove_child(child)
		facing_down_direction.add_child(child)

		child.global_transform = g_transform

	player.face_values[facing_down_direction.name] = calculate_facing_points(current_face_value, tile, facing_down_direction)


func get_facing_down_direction() -> Position3D:
	var lowest: Position3D = null
	for child in player_mesh.get_children():
		if !lowest:
			lowest = child
			continue

		var lowest_height: float = lowest.to_global(lowest.translation).y
		var child_height: float = child.to_global(child.translation).y

		if child_height < lowest_height:
			lowest = child

	return lowest


func player_can_roll(direction: Vector3):
	var target_grid_position = player_grid_position + Vector2(direction.x, direction.z)

	return not not positions.get(target_grid_position)


func calculate_facing_points(current_face_value, tile, facing_down_direction) -> int:
	if tile.value == 0:
		return current_face_value
	match current_face_value:
		0:
			return tile.value
		1:
			match tile.value:
				2:
					return 3
				4:
					return 5
				_:
					return -1
		2:
			match tile.value:
				1:
					return 3
				_:
					return -1
		4:
			match tile.value:
				1:
					return 5
				_:
					return -1
		_:
			return -1


func _on_Main_game_state_changed(to: int) -> void:
	if to == owner.IN_PROGRESS:
		run_tile_effect()
