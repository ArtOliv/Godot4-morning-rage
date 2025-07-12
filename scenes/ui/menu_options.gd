class_name MenuOptions
extends Control

signal start_game(index: int)

@onready var player_1 : LabelPicker= $WorldEnvironment/ColorRect/MarginContainer/VBoxContainer/Player1
@onready var player_2 : LabelPicker= $WorldEnvironment/ColorRect/MarginContainer/VBoxContainer/Player2
@onready var activables: Array[ActivableControl] = [player_1, player_2]

var current_selection_index := 0


func _ready() -> void:
	player_1.press.connect(on_player1_selected.bind())
	player_2.press.connect(on_player2_selected.bind())
	start_game.connect(_on_start_game.bind())
	

func _process(_delta: float) -> void:
	handle_input()

func refresh():
	for i in range(0, activables.size()):
		activables[i].set_active(current_selection_index==i)

func handle_input():
	if Input.is_action_just_pressed("ui_down"):
		current_selection_index = clampi(current_selection_index+1, 0, activables.size()-1)
		refresh()
		SoundPlayer.play(SoundManager.Sound.CLICK)
	if Input.is_action_just_pressed("ui_up"):
		current_selection_index = clampi(current_selection_index-1, 0, activables.size()-1)
		refresh()
		SoundPlayer.play(SoundManager.Sound.CLICK) 

func on_player1_selected():
	start_game.emit(0)
	queue_free()

func on_player2_selected():
	OptionsManager.select_alt_player()
	start_game.emit(1)
	queue_free()


func _on_start_game(index: int):
	OptionsManager.is_player_alt_selected = (index == 1)
