class_name Checkpoint
extends Node2D

@export var nb_simultaneous_enemies : int

@onready var enemies : Node2D = $Enemies
@onready var player_detection_area : Area2D = $PlayerDetectionArea

var active_enemy_counter := 0
var enemy_data : Array[EnemyData] = []
var is_activated := false

func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_enter.bind())
	EntityManager.death_enemy.connect(on_enemy_death.bind())
	for enemy : Character in enemies.get_children():
		enemy_data.append(EnemyData.new(enemy.type, enemy.global_position))
		enemy.queue_free()

func _process(_delta: float) -> void:
	if is_activated and can_spawn_enemies():
		var enemy : EnemyData = enemy_data.pop_front()
		EntityManager.spawn_enemy.emit(enemy)
		active_enemy_counter += 1

func can_spawn_enemies() -> bool:
	return enemy_data.size() > 0 and active_enemy_counter < nb_simultaneous_enemies

func on_player_enter(_player: Player) -> void:
	if not is_activated:
		StageManager.checkpoint_start.emit()
		active_enemy_counter = 0
		is_activated = true

func on_enemy_death(_enemy: Character) -> void:
	active_enemy_counter -= 1
	#if active_enemy_counter == 0 and enemy_data.size() == 0 and Main.current_stage_index == 2:
	#	StageManager.game_complete.emit()
	if active_enemy_counter == 0 and enemy_data.size() == 0:
		if _enemy.type == Character.Type.BOSS:
			StageManager.game_complete.emit()  # Cancela avanço automático
		else:
			StageManager.checkpoint_complete.emit(self)
			queue_free()
