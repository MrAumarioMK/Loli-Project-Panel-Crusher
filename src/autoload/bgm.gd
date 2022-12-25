# Desc:
#   AutoLoad Script
#   A background music singleton node.
#
#   Instead of having to create an AudioStreamPlayer node individually in every
#   scene that plays background music, this script simply fixes your
#   development time in one singleton node, allowing you to have more control
#   over this class.

# Usage:
#   func _ready():
#   	BGM.play(preload("res://example.ogg"))
#   
#   func _on_player_death():
#   	BGM.stop()
#   
#   One can simply create a reusable node that calls `BGM.play(export_music)`
#   at the start instead of having to assign a music file through script as 
#   the Godot won't refactor them automatically whenever the music file is
#   renamed, moved, or deleted.

# TODO:
#   - Add support for playing .mp3 tracks


extends Node


@onready
var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func play(bgm: AudioStreamOggVorbis, volume_db: float = 0.0):
	audio_stream_player.stream = bgm
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play()


func pause(paused: bool):
	audio_stream_player.stream_paused = paused


func stop():
	audio_stream_player.stream_paused = false
	audio_stream_player.stop()


func close():
	audio_stream_player.stream_paused = false
	audio_stream_player.stream = null
	stop()


func get_current_track() -> AudioStream:
	return audio_stream_player.stream

