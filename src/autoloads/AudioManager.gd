extends Node


var current_background: String
var buttons: = []


func register_button(button: Button) -> void:
	if not button: return

	button.connect("mouse_entered", self, "_on_button_hover")
	button.connect("pressed", self, "_on_button_pressed")


func _on_button_hover() -> void:
	sfx("ButtonHover")


func _on_button_pressed() -> void:
	sfx("ButtonClick")


func play(sound: String) -> void:
	for child in get_children():
		if child.name != sound:
			child.stop()

	if(current_background == sound):
		return

	current_background = sound

	get_node(sound).play()


func sfx(sound: String) -> void:
	get_node(sound).play()


func play_between_current(sound: String, restart_current: = false) -> void:
	var bg_stream_player: AudioStreamPlayer = get_node(current_background)
	var stream_player: AudioStreamPlayer = get_node(sound)
	var position: = bg_stream_player.get_playback_position()

	bg_stream_player.stop()
	stream_player.play()

	yield(stream_player, "finished")
	if current_background == bg_stream_player.name:
		bg_stream_player.play()

		if not restart_current:
			bg_stream_player.seek(position)


func toggle_music() -> void:
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))


func toggle_sound() -> void:
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))


func is_music_playing() -> bool:
	return not AudioServer.is_bus_mute(1)


func is_sfx_playing() -> bool:
	return not AudioServer.is_bus_mute(0)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_M:
			AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))



