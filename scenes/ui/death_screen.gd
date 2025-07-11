class_name DeathScreen
extends MarginContainer



@onready var timer : Timer = $Timer



func _ready() -> void:
	timer.timeout.connect(on_time_timeout.bind())


#func _process(_delta: float) -> void:
#	if current_count < countdown_start and (Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("jump")):
#		DamageManager.player_revive.emit()
#		queue_free()

func on_time_timeout():
	DamageManager.player_revive.emit()
	queue_free()
