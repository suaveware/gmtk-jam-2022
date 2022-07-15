extends CSGBox

enum Direction { RIGHT, LEFT, UP, DOWN }

const RELATION : = 0.20710678118654757

var max_height := height + height * RELATION
var min_height := height

var duration = 0.5

onready var TRANS = $Tween.TRANS_QUAD
onready var EASE = $Tween.EASE_IN


func _ready() -> void:
	yield(get_tree().create_timer(2), "timeout")
	$Tween.interpolate_method(
		self,
		"up_down",
		-1,
		1,
		duration,
		TRANS,
		EASE
	)
	$Tween.interpolate_property(
		self,
		"translation:x",
		0,
		width,
		duration,
		TRANS,
		EASE
	)
	$Tween.interpolate_property(
		self,
		"rotation:z",
		0,
		deg2rad(-90),
		duration,
		TRANS,
		EASE
	)

	$Tween.start()

func roll(direction: int) -> void:
	var start_position := translation
	var final_position_x: float
	var final_position_z: float
	var start_angle := rotation
	var final_angle := start_angle

	match direction:
		Direction.RIGHT:
			final_position_x = start_position.x + width
			final_angle.z -= PI
		Direction.LEFT:
			final_position_x = start_position.x - width
			final_angle.z += PI
		Direction.UP:
			final_position_z = start_position.z - width
			final_angle.x -= PI
		Direction.DOWN:
			final_position_z = start_position.z + width
			final_angle.x += PI

	$Tween.interpolate_method(
		self,
		"up_down",
		-1,
		1,
		duration,
		TRANS,
		EASE
	)
	$Tween.interpolate_property(
		self,
		"translation:x",
		start_position,
		final_position_x,
		duration,
		TRANS,
		EASE
	)
	$Tween.interpolate_property(
		self,
		"rotation:z",
		0,
		deg2rad(-90),
		duration,
		TRANS,
		EASE
	)

	$Tween.start()

func up_down(ammount: float) -> void:
	var difference = max_height - min_height
	translation.y = max_height - abs(ammount * difference)
