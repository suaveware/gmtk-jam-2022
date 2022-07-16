extends GridContainer

export var player_path: = NodePath()

var dice_textures = [
	preload("res://src/DiceHud/dieWhite_empty.png"),
	preload("res://src/DiceHud/dieWhite_border1.png"),
	preload("res://src/DiceHud/dieWhite_border2.png"),
	preload("res://src/DiceHud/dieWhite_border3.png"),
	preload("res://src/DiceHud/dieWhite_border4.png"),
	preload("res://src/DiceHud/dieWhite_border5.png"),
	preload("res://src/DiceHud/dieWhite_border6.png"),
]

var fail_texture = preload("res://src/DiceHud/dieRed_empty.png")


onready var player: Node = get_node(player_path)

func _process(delta: float) -> void:
	if not player: return

	for face in player.face_values.keys():
		var image_node: TextureRect = get_node(face + "/" + "FaceImage")
		var face_value = player.face_values[face]

		if face_value >= 0:
			image_node.texture = dice_textures[face_value]
		else:
			image_node.texture = fail_texture
