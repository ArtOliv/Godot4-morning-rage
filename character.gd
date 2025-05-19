extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite

enum State{IDLE, WALK}

var state = State.IDLE

func _process(delta: float) -> void:
	input()
	movement()
	animations()
	flip_sprites()
	move_and_slide()

func movement():
	if velocity.length() == 0:
		state = State.IDLE
	else:
		state = State.WALK

func input() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")

func flip_sprites():
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true
