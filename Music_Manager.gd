extends Node

@export var main_menu_music: AudioStream
@export var battle_music: AudioStream

var audio_player: AudioStreamPlayer

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	play_menu_music()

func play_menu_music():
	audio_player.stream = main_menu_music
	audio_player.play()

func play_battle_music():
	audio_player.stream = battle_music
	audio_player.play()
