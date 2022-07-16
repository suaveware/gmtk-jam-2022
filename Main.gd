extends Spatial


onready var grid = get_node("Grid")

var level = preload("res://src/levels/tutorial.tres")

var player_movements = [
	{input = "roll_up", direction = Vector3.FORWARD},
	{input = "roll_down", direction = Vector3.BACK},
	{input = "roll_right", direction = Vector3.RIGHT},
	{input = "roll_left", direction = Vector3.LEFT}
]

func _ready() -> void:
	grid.load_level(level)

func _physics_process(_delta):
	for movement in player_movements:
		if Input.is_action_pressed(movement.input) and grid.player_can_roll(movement.direction):
			$Player.roll(movement.direction)

