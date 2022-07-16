extends Node


var current_background: String

func _ready() -> void:
	pass


func play(sound: String) -> void:
	current_background = sound

	for child in get_children():
		child.stop()

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



