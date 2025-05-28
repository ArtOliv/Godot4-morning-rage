class_name Enemy
extends Character

@export var player : Player

func input() -> void:
	if player != null and can_move():
		var direction := (player.position - position).normalized()
		velocity = direction * speed
