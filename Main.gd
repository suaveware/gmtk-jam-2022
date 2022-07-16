extends Spatial


onready var grid = get_node("Grid")

var level = preload("res://src/levels/tutorial.tres")
var has_won := false

var player_movements = [
	{input = "roll_up", direction = Vector3.FORWARD},
	{input = "roll_right", direction = Vector3.RIGHT},
	{input = "roll_down", direction = Vector3.BACK},
	{input = "roll_left", direction = Vector3.LEFT}
]

func _ready() -> void:
	grid.load_level(level)

func _physics_process(_delta):
	for movement in player_movements:
		if Input.is_action_pressed(movement.input) and grid.player_can_roll(movement.direction):
			$Player.roll(movement.direction)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_R:
			grid.load_level(level)


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
	has_won = true
	pass
