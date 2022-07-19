extends Spatial

export var sensitivity = 0.2
var is_rotating = false

var prev_mouse_position
var next_mouse_position

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		is_rotating = true
		prev_mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_just_released("rotate"):
		is_rotating = false
	
	if is_rotating:
		next_mouse_position = get_viewport().get_mouse_position()
		rotate_y((prev_mouse_position.x-next_mouse_position.x) * sensitivity * delta)
		prev_mouse_position = next_mouse_position
