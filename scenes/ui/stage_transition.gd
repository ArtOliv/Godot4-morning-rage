class_name StageTransition
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start_transition():
	animation_player.play("start_transition")

func end_transition():
	animation_player.play("end_transition")

func on_start_transition_complete():
	animation_player.play("interim")
	StageManager.stage_interim.emit()

func on_complete_end_transition():
	animation_player.play("idle")
