extends TextureButton


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if is_hovered() and not pressed:
		rect_scale = Vector2(1.1, 1.1)
	else:
		rect_scale = Vector2(1, 1)
