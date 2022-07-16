extends Spatial

enum { PRE_GAME, IN_PROGRESS, PLAYER_WON }

signal game_state_changed(new_state)

onready var grid = get_node("Grid")

export var levels: = []

var game_state := PRE_GAME setget set_game_state

onready var level = load(levels[GlobalState.level_index])

var player_movements = [
	{input = "roll_up", direction = Vector3.FORWARD},
	{input = "roll_right", direction = Vector3.RIGHT},
	{input = "roll_down", direction = Vector3.BACK},
	{input = "roll_left", direction = Vector3.LEFT}
]

func _ready() -> void:
	AudioManager.play("GameLoop")
	grid.load_level(level)

func _physics_process(_delta):
	for movement in player_movements:
		if Input.is_action_pressed(movement.input) and grid.player_can_roll(movement.direction):
			$Player.roll(movement.direction)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			AudioManager.play_between_current("Lost")
			grid.load_level(level)


func next_level() -> void:
	if GlobalState.level_index < levels.size() - 1:
		GlobalState.level_index += 1
		level = load(levels[GlobalState.level_index])
		grid.load_level(level)

	AudioManager.play("GameLoop")


func _on_CameraPivot_rotated(direction: String) -> void:
	match direction:
		"left":
			var last_movement = player_movements[3].input
			player_movements[3].input = player_movements[2].input
			player_movements[2].input = player_movements[1].input
			player_movements[1].input = player_movements[0].input
			player_movements[0].input = last_movement

		"right":
			var first_movement = player_movements[0].input
			player_movements[0].input = player_movements[1].input
			player_movements[1].input = player_movements[2].input
			player_movements[2].input = player_movements[3].input
			player_movements[3].input = first_movement


func _on_Grid_player_won() -> void:
	self.game_state = PLAYER_WON
	AudioManager.play_between_current("Victory")
	next_level()
	pass


func _on_Tween_tween_all_completed() -> void:
	self.game_state = IN_PROGRESS
	pass


func set_game_state(new_state: int) -> void:
	game_state = new_state

	emit_signal("game_state_changed", new_state)


func _on_NextLevelButton_pressed() -> void:
	next_level()
	pass
