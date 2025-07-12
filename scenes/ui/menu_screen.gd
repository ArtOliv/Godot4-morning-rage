class_name MenuScreen
extends Control

@export var music : MusicManager.Music

func _ready() -> void:
	MusicPlayer.play(music)
