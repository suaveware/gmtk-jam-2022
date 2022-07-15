extends CSGBox

const DOT_POSITIONS = [
	[Vector2(0, 0)],
	[Vector2(-0.5, -0.5), Vector2(0.5, 0.5)],
	[Vector2(-0.5, -0.5), Vector2(0, 0), Vector2(0.5, 0.5)],
	[Vector2(-0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, -0.5)],
	[Vector2(-0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, -0.5), Vector2(0,0)],
	[Vector2(-0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, -0.5), Vector2(0, 0.5), Vector2(0, -0.5)]
]

export var value: int

func _ready():
	var dot_positions = DOT_POSITIONS[value-1]
	var dot = $Dot
	for i in range(len(dot_positions)):
		var new_dot = dot.duplicate()
		new_dot.set_translation(Vector3(dot_positions[i].x, 1, dot_positions[i].y))
		print(new_dot.translation)
		new_dot.visible = true
		add_child(new_dot)
	


