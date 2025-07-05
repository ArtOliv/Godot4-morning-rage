extends Node2D

const PREFAB_MAP := {
	Collectible.Type.FOOD : preload("res://scenes/characters/food.tscn")
}
const ENEMY_MAP := {
	Character.Type.ENEMY: preload("res://scenes/characters/enemy.tscn"),
	Character.Type.TREE: preload("res://scenes/characters/enemy_tree.tscn"),
	Character.Type.GOON: preload("res://scenes/characters/goon_enemy.tscn"),
	Character.Type.BOSS: preload("res://scenes/characters/boss.tscn")
}

@export var player: Player

func _ready() -> void:
	EntityManager.spawn_collectible.connect(on_spawn_collectible.bind())
	EntityManager.spawn_enemy.connect(on_spawn_enemy.bind())

func on_spawn_collectible(type: Collectible.Type, initial_state: Collectible.State, collectible_global_position: Vector2, collectible_direction: Vector2, _initial_height: float):
	var collectible: Collectible = PREFAB_MAP[type].instantiate()
	collectible.state = initial_state
	collectible.global_position = collectible_global_position
	collectible.direction = collectible_direction
	add_child(collectible)

func on_spawn_enemy(enemy_data: EnemyData) -> void:
	var enemy : Character = ENEMY_MAP[enemy_data.type].instantiate()
	enemy.global_position = enemy_data.global_position
	enemy.player = player
	add_child(enemy)
