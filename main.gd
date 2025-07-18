class_name Main
extends Node2D


const PLAYER_PREFAB := [
	preload("res://scenes/characters/player.tscn"),
	preload("res://scenes/characters/player_alt.tscn")
	]
const STAGE_PREFAB := [
	preload("res://assets/art/backgrounds/stage_01_streets.tscn"),
	preload("res://scenes/stage/stage_02.tscn"),
	preload("res://scenes/stage/stage_03.tscn")
]

@onready var actors_container :Node2D= $ActorsContainer
@onready var camera := $Camera
@onready var stage_container: Node2D = $StageContainer
@onready var stage_trasition: StageTransition = $UI/UIContainer/StageTransition
@onready var ui : UI = $UI

var initial_position_camera := Vector2.ZERO
var current_stage_index := -1
var is_camera_locked := false
var is_stage_ready_for_loading := false
var player: Player = null
var player_index := 0 
var current_health := 10 

func _ready() -> void:
	initial_position_camera = camera.position
	StageManager.checkpoint_start.connect(on_checkpoint_start.bind())
	StageManager.checkpoint_complete.connect(on_checkpoint_complete.bind())
	StageManager.stage_interim.connect(load_next_stage.bind())
	DamageManager.player_revive.connect(on_player_revive.bind())
	
	if OptionsManager.is_player_alt_selected:
		player_index = 1
	else:
		player_index = 0
	
	load_next_stage()

func _process(_delta: float) -> void:
	if is_stage_ready_for_loading:
		is_stage_ready_for_loading = false
		var stage: Stage = STAGE_PREFAB[current_stage_index].instantiate()
		stage_container.add_child(stage)
		player = PLAYER_PREFAB[player_index].instantiate()
		actors_container.add_child(player)
		player.position = stage.get_player_spawn_location()
		actors_container.player = player
		ui.on_character_health_change(player.type, current_health, player.max_health)
		player.set_health(current_health)
		camera.position = initial_position_camera
		camera.reset_smoothing()
		camera.make_current()
		stage_trasition.end_transition()	
		
	if player != null and not is_camera_locked and player.position.x > camera.position.x:
		camera.position.x = player.position.x

func load_next_stage():
	current_stage_index += 1
	if current_stage_index < STAGE_PREFAB.size():
		for actor : Node2D in actors_container.get_children():
			if player != null:	
				current_health = player.current_health
			actor.queue_free()
		
		for existing_stage in stage_container.get_children():
			existing_stage.queue_free()
			is_stage_ready_for_loading = true

func on_checkpoint_start() -> void:
	is_camera_locked = true

func on_checkpoint_complete(_checkpoint: Checkpoint) -> void:
	is_camera_locked = false

func on_player_alt_selected():
	player_index = 1

func on_player_revive():
	ui.on_character_health_change(player.type, player.max_health, player.max_health)
