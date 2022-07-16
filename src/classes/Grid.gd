extends Spatial

signal player_won

export var width := 6
export var height := 6
export var tile_size = 2

var positions := {}
var player_grid_position := Vector2.ZERO

var tile = preload("res://src/Tile/Tile.tscn")

onready var player_mesh := $"../Player/Pivot/Rotator/Mesh"
onready var player = $"../Player"

func _init() -> void:
	for i in range(0, width):
		for j in range(0, height):
			positions[Vector2(i, j)] = {}

func _ready() -> void:
	translation.x -= width *  tile_size / 2 - tile_size / 2
	translation.z -= width *  tile_size / 2 - tile_size / 2
	pass


func load_level(level = null):
	owner.game_state = owner.PRE_GAME
	player.reset()
	for child in get_children():
		positions = {}
		if(!child is Tween):
			child.queue_free()

	for tile in level.Tiles:
		instantiate_tile(tile.x, tile.y, tile.z)
	player_grid_position = level.StartPosition
	player.translation = Vector3(level.StartPosition.x* tile_size,15,level.StartPosition.y* tile_size) + translation
	$Tween.interpolate_property(
		player,
		'translation:y',
		12, 1, 1,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT, 
		((level.LevelSize.x + level.LevelSize.y) as float) / 20)
	if(level.shouldFillGrid):
		for i in range(0, level.LevelSize.x):
			for j in range(0, level.LevelSize.y):
				if(!positions.get(Vector2(i, j))):
					instantiate_tile(i, j, rand_range(0,7))
	$Tween.start()

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

	glue_balls_to_player()

	if player.has_good_faces():
		emit_signal("player_won")


func glue_balls_to_player() -> void:
	var tile = positions[player_grid_position]
	var facing_down_direction: Position3D = get_facing_down_direction()
	var is_empty = tile.get_children().size() == 0

	if is_empty:
		return

	var dots = tile.get_node('dots')

	for child in dots.get_children():
		var g_transform = child.global_transform
		dots.remove_child(child)
		facing_down_direction.add_child(child)

		child.global_transform = g_transform

	var current_face_value = player.face_values[facing_down_direction.name]

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
	if owner.game_state != owner.IN_PROGRESS:
		return false

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
		glue_balls_to_player()
