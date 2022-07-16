extends Spatial

signal moved

var face_values = { Left = 0, Right = 0, Forward = 0, Back = 0, Up = 0, Down = 0 }

export var duration = 0.5

onready var pivot = $Pivot
onready var rotator = $Pivot/Rotator
onready var mesh = $Pivot/Rotator/Mesh
onready var tween = $Tween


func roll(dir):
	# Do nothing if we're currently rolling.
	if tween.is_active():
		return

	## Step 1: Offset the pivot
	pivot.translate(dir)
	rotator.translate(-dir)

	## Step 2: Animate the rotation
	var axis = dir.cross(Vector3.DOWN)
	tween.interpolate_property(
		pivot,
		"transform:basis",
		null,
		pivot.transform.basis.rotated(axis, PI/2),
		duration,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)

	tween.start()
	yield(tween, "tween_all_completed")

	var mesh_global_transform = mesh.global_transform

	## Step3: Finalize movement and reverse the offset
	transform.origin += dir * 2
	pivot.transform = Transform.IDENTITY
	rotator.transform.origin = Vector3(0, 1, 0)

	mesh.global_transform = mesh_global_transform

	emit_signal("moved", dir)

func has_good_faces() -> bool:
	if face_values.Left + face_values.Right != 7:
		return false

	if face_values.Up + face_values.Down != 7:
		return false

	if face_values.Forward + face_values.Back != 7:
		return false

	return true


func reset() -> void:
	face_values = { Left = 0, Right = 0, Forward = 0, Back = 0, Up = 0, Down = 0 }

	for direction in mesh.get_children():
		for ball in direction.get_children():
			ball.queue_free()


func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	pivot.transform = pivot.transform.orthonormalized()
