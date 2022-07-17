extends Node

var level_index: = 0
var camera_rotation: = Vector3.ZERO
var player_movements = [
	{input = "roll_up", direction = Vector3.FORWARD},
	{input = "roll_right", direction = Vector3.RIGHT},
	{input = "roll_down", direction = Vector3.BACK},
	{input = "roll_left", direction = Vector3.LEFT}
]
