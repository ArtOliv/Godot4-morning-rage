class_name RangePicker
extends ActivableControl

const TICKS_ON := preload("res://assets/art/ui/ui-tick-on.png")
const TICKS_OFF := preload("res://assets/art/ui/ui-tick-off.png")

@onready var ticks_container: HBoxContainer = $TicksContainer

func refresh():
	var ticks:= ticks_container.get_children()
	for i in range(0, current_value):
		ticks[i].texture = TICKS_ON
	for i in range(current_value, ticks.size()):
		ticks[i].texture = TICKS_OFF

func _process(delta: float) -> void:
	if is_active and Input.is_action_just_pressed("ui_left"):
		set_value(current_value - 1)
	if is_active and Input.is_action_just_pressed("ui_right"):
		set_value(current_value + 1)
