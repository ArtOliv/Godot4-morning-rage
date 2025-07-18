extends StaticBody2D

@onready var damage_receiver := $DamageReceiver
@onready var sprite := $Sprite2D

@export var content_type : Collectible.Type
@export var knockback_intensity : float

const GRAVITY := 600.0

enum State {IDLE, DESTROYED}

var height := 0.0
var height_speed := 0.0
var state := State.IDLE
var velocity := Vector2.ZERO

func _ready() -> void:
	damage_receiver.damage_received.connect(on_receive_damage.bind())

func _process(delta: float) -> void:
	position += velocity * delta
	sprite.position = Vector2.UP * height
	handle_air_time(delta)

func on_receive_damage(_damage: int, direction: Vector2, _hit_type: DamageReceiver.HitType) -> void:
	if state == State.IDLE:
		sprite.frame = 1
		height_speed = knockback_intensity* 2
		state = State.DESTROYED
		velocity = direction * knockback_intensity
		EntityManager.spawn_collectible.emit(content_type, Collectible.State.FALL, global_position, Vector2.ZERO, 0.0)
		SoundPlayer.play(SoundManager.Sound.HIT1, true)
		
func handle_air_time(delta: float) -> void:
	if state == State.DESTROYED:
		modulate.a -= delta
		height += height_speed * delta
		if height < 0:
			height = 0
			queue_free()
		else:
			height_speed -= GRAVITY * delta
		
