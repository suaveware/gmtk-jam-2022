extends Control

export var level: Resource = Level.new()

func _ready() -> void:
	$VBoxContainer/GridContainer.columns = level.LevelSize.x
	$VBoxContainer/HBoxContainer/LevelName.text = level.resource_name
	for i in range(level.LevelSize.x):
		for j in range(level.LevelSize.y):
			var position := Vector2(i, j)
			var new_line_edit := LineEdit.new()
			new_line_edit.align = new_line_edit.ALIGN_CENTER
			new_line_edit.placeholder_text = position as String
			new_line_edit.set_meta("position", position)

			$VBoxContainer/GridContainer.add_child(new_line_edit)

	for tile in level.Tiles:
		var index: int = tile.x * level.LevelSize.x + tile.y
		var line_edit: LineEdit = $VBoxContainer/GridContainer.get_child(index)

		line_edit.text = tile.z as String


func save() -> void:
	if !$VBoxContainer/HBoxContainer/LevelName.text:
		return

	level.Tiles = []
	for line_edit in $VBoxContainer/GridContainer.get_children():
		if line_edit.text:
			var position: Vector2 = line_edit.get_meta("position")
			level.Tiles.push_back(Vector3(position.x, position.y, line_edit.text as int))

	var file_path: String = "res://src/levels/" + $VBoxContainer/HBoxContainer/LevelName.text + ".tres"
	prints("Saving ", file_path)
	ResourceSaver.save(file_path, level)


func _on_SaveButton_pressed() -> void:
	save()
	pass
