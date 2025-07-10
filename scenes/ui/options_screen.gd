class_name OpstionsScreen
extends Control


@onready var music_control: ActivableControl = $Background/MarginContainer/VBoxContainer/MusicVolumeControl
@onready var sfx_control: ActivableControl = $Background/MarginContainer/VBoxContainer/SoundVolumeControl
@onready var shake_control: ActivableControl = $Background/MarginContainer/VBoxContainer/ShakeToggle
@onready var retturn_control: ActivableControl = $Background/MarginContainer/VBoxContainer/ReturnButton
@onready var activables: Array[ActivableControl] = [music_control, sfx_control, shake_control, retturn_control]

var current_selection_index := 0

func _ready() -> void:
	refresh()

func refresh():
	for i in range(0, activables.size()):
		activables[i].set_active(current_selection_index==i)
	
func _process(delta: float) -> void:
	handle_input()

func handle_input():
	if Input.is_action_just_pressed("ui_down"):
		current_selection_index = clampi(current_selection_index+1, 0, activables.size()-1)
		refresh()
	if Input.is_action_just_pressed("ui_up"):
		current_selection_index = clampi(current_selection_index-1, 0, activables.size()-1)
		refresh()
