extends Node


var current_background: String

func _ready() -> void:
	pass


func play(sound: String) -> void:
	if(current_background == sound):
		return
	current_background = sound

	for child in get_children():
		child.stop()

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
	bg_stream_player.play()

	if not restart_current:
		bg_stream_player.seek(position)


func toggle_music() -> void:
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))


func toggle_sound() -> void:
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_M:
			AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))



