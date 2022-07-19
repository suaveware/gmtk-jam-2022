extends Spatial

enum { PRE_GAME, IN_PROGRESS, PLAYER_WON, ENDED }

signal game_state_changed(new_state)

onready var grid = $Grid
onready var camera = $CameraPivot/Camera

export var levels: = []

var game_state := PRE_GAME setget set_game_state

onready var level = load(levels[GlobalState.level_index])

func _ready() -> void:
	AudioManager.play("GameLoop")
	grid.load_level(level)

	for button in get_tree().get_nodes_in_group("button"):
		AudioManager.register_button(button)

func _physics_process(_delta):
	for movement in GlobalState.player_movements:
		if game_state == IN_PROGRESS and Input.is_action_pressed(movement.input):
			move_player(movement.direction)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			reset_level()

		if event.scancode == KEY_B:
			back_to_menu()

		if event.scancode == KEY_ENTER and game_state == PLAYER_WON:
			next_level()
	elif event is InputEventMouseButton and event.pressed:
		
		var space_state = get_world().direct_space_state
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_pos)*100
		var ray_array = space_state.intersect_ray(ray_origin, ray_end)
		if('collider' in ray_array and ray_array['collider'].get_parent() is Tile):
			var tile = ray_array.collider.get_parent()
			print(tile.grid_position)
			var direction = tile.grid_position - grid.player_grid_position
			if (direction.length() <=1):
				move_player(Vector3(direction.x, 0,direction.y))

func move_player(direction):
	if grid.player_can_roll(direction):
		$Player.roll(direction)
	else:
		$Player.try_roll(direction)

func reset_level() -> void:
	AudioManager.play_between_current("Lost")
	grid.deload_level()
	yield(grid, "level_deloaded")
	get_tree().reload_current_scene()
	pass


func back_to_menu() -> void:
	get_tree().change_scene("res://src/StartMenu/StartMenu.tscn")


func next_level() -> void:
	if GlobalState.level_index < levels.size() - 1:
		GlobalState.level_index += 1
		level = load(levels[GlobalState.level_index])
		grid.load_level(level)
	else:
		self.game_state = ENDED

	AudioManager.play("GameLoop")


func _on_CameraPivot_rotated(direction: String) -> void:
	match direction:
		"left":
			var last_movement = GlobalState.player_movements[3].input
			GlobalState.player_movements[3].input = GlobalState.player_movements[2].input
			GlobalState.player_movements[2].input = GlobalState.player_movements[1].input
			GlobalState.player_movements[1].input = GlobalState.player_movements[0].input
			GlobalState.player_movements[0].input = last_movement

		"right":
			var first_movement = GlobalState.player_movements[0].input
			GlobalState.player_movements[0].input = GlobalState.player_movements[1].input
			GlobalState.player_movements[1].input = GlobalState.player_movements[2].input
			GlobalState.player_movements[2].input = GlobalState.player_movements[3].input
			GlobalState.player_movements[3].input = first_movement


func _on_Grid_player_won() -> void:
	self.game_state = PLAYER_WON
	AudioManager.play_between_current("Victory")
	$Player.visible = false
	$CameraPivot/Camera/victory_dice.visible = true
	
func _on_level_loaded() -> void:
	$Player.visible = true
	$CameraPivot/Camera/victory_dice.visible = false

func _on_Tween_tween_all_completed() -> void:
	self.game_state = IN_PROGRESS

func set_game_state(new_state: int) -> void:
	game_state = new_state

	emit_signal("game_state_changed", new_state)


func _on_NextLevelButton_pressed() -> void:
	next_level()

func _on_MusicToggle_toggled(button_pressed: bool) -> void:
	AudioManager.toggle_music()


func _on_SoundToggle_toggled(button_pressed: bool) -> void:
	AudioManager.toggle_sound()

func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene("res://src/StartMenu/StartMenu.tscn")
