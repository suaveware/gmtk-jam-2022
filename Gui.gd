extends Control


func _ready() -> void:
	print(AudioManager.is_music_playing())
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
