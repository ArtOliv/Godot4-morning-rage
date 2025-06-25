class_name Collectible
extends Area2D

const GRAVITY := 600.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collectible_sprite: Sprite2D = $FoodSprite

@export var knockdown_intensity: float
@export var speed: float
@export var type: Type

enum State {FALL, GROUNDED}
enum Type {FOOD}

var anim_map : Dictionary= {
	State.FALL: "fall",
	State.GROUNDED: "grounded", 
}

var height := 0.0
var height_speed := 0.0
var state = State.FALL

func _ready():
	height_speed = knockdown_intensity

func _process(delta: float) -> void:
	handle_fall(delta)
	handle_animations()
	collectible_sprite.position = Vector2.UP * height

func handle_animations():
	animation_player.play(anim_map[state])

func handle_fall(delta):
	if state == State.FALL:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.GROUNDED
		else:
			height_speed -= GRAVITY * delta
