class_name Player
extends Character

const REVIVE_HIGHT := 20

@export var max_duration_between_succesful_hit : int 
@export var lifes : int

@onready var enemy_slots : Array = $EnemySlots.get_children()

var time_since_last_succesful_attack := Time.get_ticks_msec()

func _ready() -> void:
	super._ready()
	anim_attacks = ["punch", "punch_alt", "kick", "roundkick"]
	DamageManager.player_revive.connect(on_player_revive.bind())

func _process(delta: float) -> void:
	super._process(delta)
	
	process_time_between_combos()
	
func process_time_between_combos():
	if Time.get_ticks_msec() - time_since_last_succesful_attack > max_duration_between_succesful_hit:
		attack_combo_index = 0

func on_player_revive():
	current_health = max_health
	state = State.JUMP
	height = 0
	StageManager.player_revived = true

func input() -> void:
	if state == State.ATTACK:
		velocity = Vector2.ZERO
		return
	if not can_move():
		velocity = Vector2.ZERO
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		velocity = Vector2.ZERO
		if can_pickup_collectible():
			state = State.PICKUP
		else:
			state = State.ATTACK
			SoundPlayer.play(SoundManager.Sound.SWOOSH)
			already_hit.clear()
			if is_last_hit_succesful:
				time_since_last_succesful_attack = Time.get_ticks_msec()
				attack_combo_index = (attack_combo_index+1) % anim_attacks.size()
				is_last_hit_succesful = false
			else:
				attack_combo_index = 0
	if can_jump() and Input.is_action_just_pressed("jump"):
		state = State.TAKEOFF
		attack_combo_index = 0

	if can_jumpkick() and Input.is_action_just_pressed("attack"):
		state = State.JUMPKICK
		SoundPlayer.play(SoundManager.Sound.SWOOSH)

func set_heading():
	if can_move():
		if velocity.x > 0:
			heading = Vector2.RIGHT
		elif velocity.x < 0: 
			heading = Vector2.LEFT

func reserve_slot(enemy: Enemy) -> EnemySlot:
	var available_slots := enemy_slots.filter(
		func(slot): return slot.is_free()
	)
	if available_slots.size() == 0:
		return null
	available_slots.sort_custom(
		func(a:EnemySlot, b:EnemySlot):
			var dist_a := (enemy.global_position - a.global_position).length()
			var dist_b := (enemy.global_position - b.global_position).length()
			return dist_a < dist_b
	)
	available_slots[0].occupy(enemy)
	return available_slots[0]
	
func free_slot(enemy: Enemy):
	var target_slots:= enemy_slots.filter(
		func(slot: EnemySlot): return slot.occupant == enemy
	)
	if target_slots.size() == 1:
		target_slots[0].free_up()

func get_max_health():
	return max_health
