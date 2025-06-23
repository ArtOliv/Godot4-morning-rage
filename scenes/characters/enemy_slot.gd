class_name EnemySlot
extends Node2D

var occupant: Enemy  = null

func is_free() ->bool:
	return occupant == null

func free_up():
	occupant = null

func occupy(enemy: Enemy):
	occupant = enemy
