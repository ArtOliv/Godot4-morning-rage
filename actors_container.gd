extends Node2D

var prefab_map := {
	Collectible.Type.FOOD : preload("res://scenes/characters/food.tscn"),
}

func _ready() -> void:
	EntityManager.spawn_collectible.connect(on_spawn_collectible.bind())

func on_spawn_collectible(type: Collectible.Type, initial_state: Collectible.State, collectible_global_position: Vector2, collectible_direction: Vector2, initial_height: float):
	var collectible: Collectible = prefab_map[type].instantiate()
	collectible.state = initial_state
	collectible.global_position = collectible_global_position
	collectible.direction = collectible_direction
	add_child(collectible)
	
