extends Control


func _ready() -> void:

	pass


func _on_Main_game_state_changed(new_state) -> void:
	match new_state:
		owner.PRE_GAME:
			$NiceRoll.hide()
			$DiceHud.hide()
			$HBoxContainer.hide()
		owner.IN_PROGRESS:
			$DiceHud.show()
			$HBoxContainer.show()
		owner.PLAYER_WON:
			$NiceRoll.show()
#			$DiceHud.hide()
			$HBoxContainer.hide()
		owner.ENDED:
			$NiceRoll.hide()
			$DiceHud.hide()
			$EndScreen.show()
