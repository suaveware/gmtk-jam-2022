extends Spatial

signal moved

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
		Tween.TRANS_CIRC,
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


func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	pivot.transform = pivot.transform.orthonormalized()
