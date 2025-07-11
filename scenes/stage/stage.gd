class_name Stage
extends Node2D

@onready var containers : Node2D = $Containers
@onready var player_spawn_location : Node2D = $PlayerLocalSpawn
@onready var checkpoints:= $Checkpoints

@export var music: MusicManager.Music

func _init() -> void:
	StageManager.checkpoint_complete.connect(on_checkpoint_complete.bind())

func _ready() -> void:
	for container : Node2D in containers.get_children():
		EntityManager.orphan_actor.emit(container)
	
	MusicPlayer.play(music)

func get_player_spawn_location():
	return player_spawn_location.position

func on_checkpoint_complete(checkpoint: Checkpoint):
	if checkpoints.get_child(-1) == checkpoint:
		StageManager.stage_complete.emit()
