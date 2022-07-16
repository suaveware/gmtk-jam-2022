extends Control

func _ready() -> void:
	AudioManager.play("MenuLoop")
	pass


func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://src/tutorial/Tutorial.tscn")
	pass

func _on_LevelsButton_pressed() -> void:
	get_tree().change_scene("res://src/LevelsMenu/LevelsMenu.tscn")
	pass

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
	pass
