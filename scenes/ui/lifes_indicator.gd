class_name LifesIndicator
extends Label

signal game_over

@export var lifes : int

var current_lifes =  0

func _init() -> void:
	DamageManager.player_revive.connect(on_player_revive.bind())

func _ready() -> void:
	current_lifes = lifes
	refresh()

func _process(_delta: float) -> void:
	if int(text)  == 0:
		game_over.emit()

func refresh():
	text = str(current_lifes)
	
func on_player_revive():
	current_lifes -= 1
	refresh()
