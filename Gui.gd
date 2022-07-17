extends Control


onready var camera_pivot: Spatial = $"../../CameraPivot"


func _ready() -> void:
	$VBoxContainer/MusicToggle.set_pressed_no_signal(not AudioManager.is_music_playing())
	$VBoxContainer/SoundToggle.set_pressed_no_signal(not AudioManager.is_sfx_playing())
	pass


func _process(delta: float) -> void:
	$LevelNumber.text = (GlobalState.level_index + 1) as String


func _on_Main_game_state_changed(new_state) -> void:
	match new_state:
		owner.PRE_GAME:
			$LevelNumber.show()
			$NiceRoll.hide()
			$DiceHud.show()
			$HBoxContainer.show()
		owner.IN_PROGRESS:
			$LevelNumber.show()
			$DiceHud.show()
			$HBoxContainer.show()
		owner.PLAYER_WON:
			$NiceRoll.show()
#			$DiceHud.hide()
			$HBoxContainer.hide()
		owner.ENDED:
			$LevelNumber.hide()
			$NiceRoll.hide()
			$DiceHud.hide()
			$EndScreen.show()

func _on_BackToMenu_pressed() -> void:
	owner.back_to_menu()
	pass

func _on_Reset_pressed() -> void:
	owner.reset_level()
	pass

func _on_RotateLeft_pressed() -> void:
	camera_pivot.rotate_left()
	pass

func _on_RotateRight_pressed() -> void:
	camera_pivot.rotate_right()
	pass
