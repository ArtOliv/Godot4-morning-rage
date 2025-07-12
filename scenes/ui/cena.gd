class_name Cena
extends Control

signal end

@onready var timer : Timer = $WorldEnvironment/Timer

func _ready() -> void:
	timer.timeout.connect(on_timeout.bind())
	
func on_timeout():
	end.emit()
	queue_free()
