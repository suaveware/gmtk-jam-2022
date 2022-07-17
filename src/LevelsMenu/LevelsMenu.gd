extends Control

var level_quantity = 9

var LevelButton = preload("res://src/LevelsMenu/LevelButton.tscn")
onready var button_grid = $GridContainer


func _ready():
	var tutorialButton = LevelButton.instance()
	tutorialButton.text = 'Tutorial'
	button_grid.add_child(tutorialButton)
	tutorialButton.connect("button_up", self, "_on_tutorialButton_pressed")

	for i in range(0, level_quantity):
		var button = LevelButton.instance()
		button.text = 'Level '+((i+1) as String)
		button_grid.add_child(button)
		button.connect("button_up", self, "_on_button_pressed", [i])
		button.add_to_group("button")

	for button in get_tree().get_nodes_in_group("button"):
		AudioManager.register_button(button)


func _on_button_pressed(level):
	GlobalState.level_index = level
	get_tree().change_scene("res://Main.tscn")

func _on_tutorialButton_pressed():
	get_tree().change_scene("res://src/tutorial/Tutorial.tscn")

func _on_MenuButton_pressed():
	get_tree().change_scene("res://src/StartMenu/StartMenu.tscn")
