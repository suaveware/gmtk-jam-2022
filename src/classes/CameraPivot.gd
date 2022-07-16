extends Spatial

signal rotated

var rotation_duration := 1

func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_right"):
		rotate_right()
	if Input.is_action_pressed("rotate_left"):
		rotate_left()

func rotate_right() -> void:
	if $Tween.is_active():
		return

	$Tween.interpolate_property(
		self,
		"rotation:y",
		rotation.y,
		rotation.y + PI / 2,
		rotation_duration,
		$Tween.TRANS_QUAD,
		$Tween.EASE_IN_OUT
	)
	$Tween.start()
	AudioManager.sfx("CameraRotate")
	emit_signal("rotated", "right")
	pass

func rotate_left() -> void:
	if $Tween.is_active():
		return

	$Tween.interpolate_property(
		self,
		"rotation:y",
		rotation.y,
		rotation.y - PI / 2,
		rotation_duration,
		$Tween.TRANS_QUAD,
		$Tween.EASE_IN_OUT
	)
	$Tween.start()
	AudioManager.sfx("CameraRotate")
	emit_signal("rotated", "left")
	pass

