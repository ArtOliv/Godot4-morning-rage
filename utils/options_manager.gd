
extends Node

signal player_alt_selected

var is_screenshake_enabled := true
var music_volume := 5
var sfx_volume := 5
var is_player_alt_selected: bool = false

func set_music_volume(value: int):
	music_volume = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value/10.0))

func set_sfx_volume(value: int):
	sfx_volume = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value/10.0))

func set_screenshake(value: bool):
	is_screenshake_enabled = value

func select_alt_player():
	is_player_alt_selected = true
	player_alt_selected.emit()
