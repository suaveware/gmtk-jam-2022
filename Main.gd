extends Spatial

onready var grid = get_node("Grid")

var level = preload("res://src/levels/tutorial.tres")

func _ready() -> void:
	grid.load_level(level)
