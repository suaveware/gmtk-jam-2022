extends Spatial

enum Type { UNGLUE = 7 }

const DOT_POSITIONS = [[],
	[Vector2(0, 0)],
	[Vector2(-0.5, -0.5), Vector2(0.5, 0.5)],
	[Vector2(-0.5, -0.5), Vector2(0, 0), Vector2(0.5, 0.5)],
	[Vector2(-0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, -0.5)],
	[Vector2(-0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, -0.5), Vector2(0,0)],
	[Vector2(-0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, -0.5), Vector2(0, 0.5), Vector2(0, -0.5)]
]

export var value: int


func _ready():
	match value:
		Type.UNGLUE:
			$Thrashcan.show()
		_:
			var dot_positions = DOT_POSITIONS[value]
			var dot = $Dot
			for i in range(len(dot_positions)):
				var new_dot = dot.duplicate()
				new_dot.set_translation(Vector3(dot_positions[i].x, 1, dot_positions[i].y))
				new_dot.visible = true
				$dots.add_child(new_dot)



