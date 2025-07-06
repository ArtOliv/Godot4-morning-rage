class_name ComboIndicator
extends Label

signal combo_reset(points: int)

@export var duration_combo_timeout: int

var current_combo := 0
var time_since_register_hit := Time.get_ticks_msec()

func _init() -> void:
	ComboManager.register_hit.connect(on_register_hit.bind())

func _ready() -> void:
	refresh()

func on_register_hit():
	current_combo += 1
	time_since_register_hit = Time.get_ticks_msec()
	refresh()

func _process(_delta: float) -> void:
	if current_combo > 0 and (Time.get_ticks_msec() - time_since_register_hit) > duration_combo_timeout:
		combo_reset.emit(current_combo)
		current_combo = 0
		refresh()
	
func refresh():
	text = "x" + str(current_combo)	
