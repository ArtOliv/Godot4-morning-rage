class_name Stage
extends Node2D

@onready var containers : Node2D = $Containers

@export var music: MusicManager.Music

func _ready() -> void:
	for container : Node2D in containers.get_children():
		EntityManager.orphan_actor.emit(container)
	
	MusicPlayer.play(music)
