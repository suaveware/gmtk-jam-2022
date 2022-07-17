extends Control

func _ready() -> void:
	AudioManager.play("MenuLoop")

	for button in get_tree().get_nodes_in_group("button"):
		AudioManager.register_button(button)
	pass


func _on_StartButton_pressed() -> void:
	GlobalState.level_index = 0
	get_tree().change_scene("res://src/tutorial/Tutorial.tscn")
	pass

func _on_LevelsButton_pressed() -> void:
	get_tree().change_scene("res://src/LevelsMenu/LevelsMenu.tscn")
	pass

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
	pass
