class_name DeathScreen
extends MarginContainer

signal game_over

@onready var timer : Timer = $Timer
@onready var countdown_label : Label = $Border/MarginContainer/Contents/VBoxContainer/CountdownLabel

@export var countdown_start : int

var current_count := 0

func _ready() -> void:
	current_count = countdown_start
	timer.timeout.connect(on_time_timeout.bind())
	refresh()

func refresh():
	countdown_label.text = str(current_count)

func _process(_delta: float) -> void:
	if current_count < countdown_start and (Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("jump")):
		DamageManager.player_revive.emit()
		queue_free()

func on_time_timeout():
	if current_count > 0:
		current_count -= 1
		refresh()
	else:
		game_over.emit()
		queue_free()
