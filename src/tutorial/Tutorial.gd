extends Spatial

export(NodePath) var label_path
onready var label = get_node(label_path)

export(Array) var slides
export(Array) var slideTexts
var current_slide = 0

func _ready():
	update_slide()

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			next_slide()


func next_slide():
	if(current_slide == slides.size() - 1):
		get_tree().change_scene("res://Main.tscn")
		return
	get_node(slides[current_slide]).visible = false
	current_slide += 1
	update_slide()

func update_slide():
	get_node(slides[current_slide]).visible = true
	if(label):
		var text
		if(slideTexts[current_slide]):
			text = slideTexts[current_slide]
		text += '\n\nPress any key to continue...'
		label.text = text

