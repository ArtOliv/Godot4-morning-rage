extends Node

signal checkpoint_start
signal checkpoint_complete(checkpoint: Checkpoint)
signal stage_complete
signal stage_interim
signal game_complete
var player_revived := false
