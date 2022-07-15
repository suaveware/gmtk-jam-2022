extends Spatial


export var duration = 0.5

onready var pivot = $Pivot
onready var mesh = $Pivot/Mesh
onready var tween = $Tween


func _physics_process(_delta):
	var forward = Vector3.FORWARD
	if Input.is_action_pressed("roll_up"):
		roll(forward)
	if Input.is_action_pressed("roll_down"):
		roll(-forward)
	if Input.is_action_pressed("roll_right"):
		roll(forward.cross(Vector3.UP))
	if Input.is_action_pressed("roll_left"):
		roll(-forward.cross(Vector3.UP))


func roll(dir):
	# Do nothing if we're currently rolling.
	if tween.is_active():
		return

	## Step 1: Offset the pivot
	pivot.translate(dir)
	mesh.translate(-dir)

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

	## Step3: Finalize movement and reverse the offset
	transform.origin += dir * 2
	pivot.transform = Transform.IDENTITY
	mesh.transform.origin = Vector3(0, 1, 0)

func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	pivot.transform = pivot.transform.orthonormalized()
