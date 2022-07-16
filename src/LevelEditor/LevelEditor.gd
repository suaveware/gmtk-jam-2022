extends Control

export var size := Vector2(10, 10)
export var start_position := Vector2(6, 6)

func _ready() -> void:
	for i in range(size.x):
		for j in range(size.y):
			var position := Vector2(i, j)
			var new_line_edit := LineEdit.new()
			new_line_edit.align = new_line_edit.ALIGN_CENTER
			new_line_edit.placeholder_text = position as String
			new_line_edit.set_meta("position", position)
			$VBoxContainer/GridContainer.add_child(new_line_edit)


func save() -> void:
	if !$VBoxContainer/HBoxContainer/LevelName.text:
		return

	var level := Level.new()
	level.LevelSize = size
	level.StartPosition = start_position

	for line_edit in $VBoxContainer/GridContainer.get_children():
		if line_edit.text:
			var position: Vector2 = line_edit.get_meta("position")
			level.Tiles.push_back(Vector3(position.x, position.y, line_edit.text as int))

	var file_path: String = "res://levels/" + $VBoxContainer/HBoxContainer/LevelName.text + ".tres"
	prints("Saving ", file_path)
	ResourceSaver.save(file_path, level)


func _on_SaveButton_pressed() -> void:
	save()
	pass
