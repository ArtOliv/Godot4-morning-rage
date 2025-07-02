class_name Character
extends CharacterBody2D

const GRAVITY := 600.0
@export var can_respawn : bool
@export var damage : int
@export var damage_power: int
@export var max_health : int

@export_group("Movement")
@export var duration_grounded: float
@export var flight_speed: float
@export var jump_intesity : float
@export var knockback_intensity : float
@export var knockdown_intensity: float
@export var speed : float






@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite
@onready var collision_shape := $CollisionShape2D
@onready var collateral_damage_emitter : Area2D= $CollateralDamageEmitterer
@onready var collectible_sensor: Area2D = $CollectibleSensor
@onready var damage_emitter := $DamageEmitter
@onready var damage_receiver : DamageReceiver = $DamageReceiver

enum State{IDLE, WALK, ATTACK, TAKEOFF, JUMP, LAND, JUMPKICK, 
		   HURT, FALL, GROUNDED, DEATH, FLY, PREP_ATTACK, PICKUP}

var anim_attacks := []
var anim_map : Dictionary= {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.TAKEOFF: "takeoff",
	State.JUMP: "jump",
	State.LAND: "land",
	State.JUMPKICK: "jumpkick",
	State.HURT: "hurt", 
	State.FALL: "fall",
	State.GROUNDED: "grounded", 
	State.DEATH: "grounded",
	State.FLY: "fly",
	State.PREP_ATTACK: "idle",
	State.PICKUP: "pickup"
}

var attack_combo_index := 0
var current_health := 0
var heading := Vector2.RIGHT
var height := 0.0
var height_speed := 0.0
var is_last_hit_succesful := false
var state = State.IDLE
var time_since_grounded = Time.get_ticks_msec()
var already_hit := []

func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_receiver.damage_received.connect(on_receive_damage.bind())
	collateral_damage_emitter.area_entered.connect(on_emit_collateral_damage.bind())
	collateral_damage_emitter.body_entered.connect(on_wall_hit.bind())
	current_health = max_health

func _process(delta: float) -> void:
	input()
	movement()
	animations()
	air_time(delta)
	prep_attack()
	grounded()
	death(delta)
	set_heading()
	flip_sprites()
	character_sprite.position = Vector2.UP * height
	collision_shape.disabled = is_collision_disabled()
	damage_emitter.monitoring = is_attacking()
	damage_receiver.monitorable = can_get_hurt()
	move_and_slide()

func movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK

func input() -> void:
	pass

func grounded():
	if state == State.GROUNDED and (Time.get_ticks_msec() - time_since_grounded > duration_grounded):
		if current_health == 0:
			state = State.DEATH
		else:
			state = State.LAND
		

func death(delta: float):
	if state == State.DEATH and not can_respawn:
		modulate.a -= delta/2.0
		if modulate.a == 0:
			queue_free()

func animations() -> void:
	if state == State.ATTACK:
		animation_player.play(anim_attacks[attack_combo_index])
	elif animation_player.has_animation(anim_map[state]):
		animation_player.play(anim_map[state])

func set_heading():
	pass
	

func flip_sprites() -> void:
	if heading == Vector2.RIGHT:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	else:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1

func air_time(delta: float) -> void:
	if [State.JUMP, State.JUMPKICK, State.FALL].has(state):
		height += height_speed * delta
		if height < 0:
			height = 0
			if state == State.FALL:
				state = State.GROUNDED
				time_since_grounded = Time.get_ticks_msec()
			else:
				state = State.LAND
			velocity = Vector2.ZERO
		else:
			height_speed -= GRAVITY * delta

func prep_attack():
	pass

func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

func can_jumpkick() -> bool:
	return state == State.JUMP
	
func can_get_hurt() -> bool:
	return [State.IDLE, State.WALK, State.TAKEOFF, State.LAND, State.PREP_ATTACK].has(state)

func is_attacking()-> bool:
	return [State.ATTACK, State.JUMPKICK].has(state)

func can_pickup_collectible() -> bool:
	var collectible_areas := collectible_sensor.get_overlapping_areas()
	if collectible_areas.size() == 0:
		return false
	var collectible: Collectible = collectible_areas[0]
	if collectible.type == Collectible.Type.FOOD:
		return true
	return false

func pickup_collectible():
	if can_pickup_collectible():
		var collectible_areas := collectible_sensor.get_overlapping_areas()
		var collectible: Collectible = collectible_areas[0]
		if collectible.type == Collectible.Type.FOOD:
			current_health = max_health
		collectible.queue_free()
func is_collision_disabled() -> bool:
	return [State.GROUNDED, State.DEATH, State.FLY].has(state)
	

func on_action_comlpete() -> void:
	state = State.IDLE
	
func on_takeoff_complete() -> void:
	state = State.JUMP
	height_speed = jump_intesity

func on_land_complete() -> void:
	state = State.IDLE	
	
func on_pickup_complete() -> void:
	state = State.IDLE
	pickup_collectible()

func on_receive_damage(amount: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	if can_get_hurt():
		attack_combo_index = 0
		current_health = clamp(current_health - amount, 0, max_health)
		if current_health == 0 or hit_type == DamageReceiver.HitType.KNOCKDOWN:
			state = State.FALL
			height_speed = knockdown_intensity
			velocity = direction * knockback_intensity
		elif hit_type == DamageReceiver.HitType.POWER:
			state = State.FLY
			velocity = direction * flight_speed
		else:
			state = State.HURT
			velocity = direction * knockback_intensity

func on_emit_damage(receiver: DamageReceiver) -> void:
	if receiver in already_hit:
		return
	already_hit.append(receiver)
	var hit_type := DamageReceiver.HitType.NORMAL
	var direction := Vector2.LEFT if receiver.global_position.x < global_position.x else Vector2.RIGHT
	var current_damage = damage
	if state == State.JUMPKICK:
		hit_type = DamageReceiver.HitType.KNOCKDOWN
	if attack_combo_index == anim_attacks.size() -1:
		hit_type = DamageReceiver.HitType.POWER
		current_damage = damage_power
	receiver.damage_received.emit(current_damage, direction, hit_type)
	is_last_hit_succesful = true

func on_emit_collateral_damage(receiver: DamageReceiver):
	if receiver != damage_receiver:
		var direction := Vector2.LEFT if receiver.global_position.x < global_position.x else Vector2.RIGHT
		receiver.damage_received.emit(0, direction, DamageReceiver.HitType.KNOCKDOWN)

func on_wall_hit(_wall: AnimatableBody2D):
	state = State.FALL
	height_speed = knockdown_intensity
	velocity = -velocity/2.0
