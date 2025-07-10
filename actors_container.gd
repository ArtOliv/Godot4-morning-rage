extends Node2D

const SPARK_PREFAB := preload("res://scenes/props/spark.tscn")
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

func _init() -> void:
	EntityManager.spawn_collectible.connect(on_spawn_collectible.bind())
	EntityManager.spawn_enemy.connect(on_spawn_enemy.bind())
	EntityManager.orphan_actor.connect(on_orphan_actor.bind())
	EntityManager.spawn_spark.connect(on_spawn_spark.bind())

func on_spawn_collectible(type: Collectible.Type, initial_state: Collectible.State, collectible_global_position: Vector2, collectible_direction: Vector2, _initial_height: float):
	var collectible: Collectible = PREFAB_MAP[type].instantiate()
	collectible.state = initial_state
	collectible.global_position = collectible_global_position
	collectible.direction = collectible_direction
	call_deferred("add_child", collectible)

func on_spawn_enemy(enemy_data: EnemyData) -> void:
	var type_enum = enemy_data.type
	
	# Se for string, converte para inteiro
	if typeof(type_enum) == TYPE_STRING:
		type_enum = Character.Type.get(type_enum, -1)
	
	if not ENEMY_MAP.has(type_enum):
		print("Tipo de inimigo inválido: ", str(enemy_data.type))
		return
	
	var enemy : Character = ENEMY_MAP[type_enum].instantiate()
	enemy.global_position = enemy_data.global_position
	enemy.player = player
	add_child(enemy)

func on_orphan_actor(orphan: Node2D) -> void:
	orphan.reparent(self)

func on_spawn_spark(spark_position: Vector2):
	var spark_instance := SPARK_PREFAB.instantiate()
	spark_instance.position = spark_position
	add_child(spark_instance)
