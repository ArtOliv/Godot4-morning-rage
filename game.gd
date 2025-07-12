extends Node2D

const MENU_OPTIONS_PREFAB := preload("res://scenes/ui/menu_options.tscn")
const MAIN_PREFAB := preload("res://main.tscn")

@onready var menu_screen : MenuScreen = $MenuScreen

var menu_options : MenuOptions = null
var main : Main = null




func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		menu_screen.queue_free()
		menu_options = MENU_OPTIONS_PREFAB.instantiate()
		add_child(menu_options)
		menu_options.start_game.connect(on_start_game.bind())

func on_start_game(index: int):
	main = MAIN_PREFAB.instantiate()
	add_child(main)
