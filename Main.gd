extends Spatial


onready var grid = get_node("Grid")

var level = preload("res://src/levels/tutorial.tres")

func _ready() -> void:
	grid.load_level(level)

func _physics_process(_delta):
	if Input.is_action_pressed("roll_up"):
		$Player.roll(Vector3.FORWARD)
	if Input.is_action_pressed("roll_down"):
		$Player.roll(Vector3.BACK)
	if Input.is_action_pressed("roll_right"):
		$Player.roll(Vector3.RIGHT)
	if Input.is_action_pressed("roll_left"):
		$Player.roll(Vector3.LEFT)
