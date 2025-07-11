extends Node2D

const PLAYER_PREFAB := preload("res://scenes/characters/player.tscn")
const STAGE_PREFAB := [
	preload("res://assets/art/backgrounds/stage_01_streets.tscn"),
	preload("res://scenes/stage/stage_02.tscn")
]

@onready var actors_container :Node2D= $ActorsContainer
@onready var camera := $Camera
@onready var stage_container: Node2D = $StageContainer
@onready var stage_trasition: StageTransition = $UI/UIContainer/StageTransition

var initial_position_camera := Vector2.ZERO
var current_stage_index := -1
var is_camera_locked := false
var is_stage_ready_for_loading := false
var player: Player = null

func _ready() -> void:
	initial_position_camera = camera.position
	StageManager.checkpoint_start.connect(on_checkpoint_start.bind())
	StageManager.checkpoint_complete.connect(on_checkpoint_complete.bind())
	StageManager.stage_interim.connect(load_next_stage.bind())
	load_next_stage()

func _process(_delta: float) -> void:
	if is_stage_ready_for_loading:
		is_stage_ready_for_loading = false
		var stage: Stage = STAGE_PREFAB[current_stage_index].instantiate()
		stage_container.add_child(stage)
		player = PLAYER_PREFAB.instantiate()
		actors_container.add_child(player)
		player.position = stage.get_player_spawn_location()
		actors_container.player = player
		camera.position = initial_position_camera
		camera.reset_smoothing()
		stage_trasition.end_transition()	
		
	if player != null and not is_camera_locked and player.position.x > camera.position.x:
		camera.position.x = player.position.x

func load_next_stage():
	current_stage_index += 1
	if current_stage_index < STAGE_PREFAB.size():
		for actor : Node2D in actors_container.get_children():
			actor.queue_free()
		
		for existing_stage in stage_container.get_children():
			existing_stage.queue_free()
			is_stage_ready_for_loading = true

func on_checkpoint_start() -> void:
	is_camera_locked = true

func on_checkpoint_complete(_checkpoint: Checkpoint) -> void:
	is_camera_locked = false

	
