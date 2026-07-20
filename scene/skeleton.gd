extends Node2D

@export var max_hp := 35
@export var damage := 15

signal hp_changed(current_hp)
signal died

var hp : int

@export var attack_delay = [
	1.0,
	1.5,
	2.0
]

var attack_timer := 0.0

enum State {
	IDLE,
	ATTACK,
	DEAD,
	DEACTIVATE
}

var state = State.IDLE

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $HitBox/CollisionShape2D
@onready var hurtbox = $HurtBox/CollisionShape2D

func _ready():
	hp = max_hp
	sprite.play("idle")
	hp_changed.emit(hp)
	attack_timer = attack_delay.pick_random()

func _process(delta):
	if state == State.IDLE:
		attack_timer -= delta

		if attack_timer <= 0:
			attack()

func attack():
	state = State.ATTACK
	sprite.play("attack")
	$AnimationPlayer.play("attack")
	hitbox.disabled = false

func hit(dmg):
	if state == State.DEAD:
		return

	hp -= dmg
	hp_changed.emit(hp)

	flash()

	if hp <= 0:
		die()

func flash():
	sprite.modulate = Color(3,3,3)
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color.WHITE

func die():
	if state == State.DEAD:
		return

	state = State.DEAD

	hurtbox.set_deferred("disabled", true)
	hitbox.set_deferred("disabled", true)

	sprite.play("dead")

	died.emit()
	
func reset_enemy():
	await get_tree().create_timer(0.5).timeout
	hp = max_hp
	state = State.IDLE

	visible = true

	hurtbox.set_deferred("disabled", false)
	hitbox.set_deferred("disabled", true)

	sprite.play("idle")

	hp_changed.emit(hp)

	attack_timer = attack_delay.pick_random()
func deactivate():
	state = State.DEACTIVATE

	visible = false
	hurtbox.disabled = true
	hitbox.set_deferred("disabled", true)
	
func _on_animated_sprite_2d_animation_finished():
	match state:
		State.ATTACK :
			state = State.IDLE
			sprite.play("idle")
			hitbox.set_deferred("disabled", true)
			attack_timer = attack_delay.pick_random()

		State.DEAD:
			visible = false

func _on_hit_box_area_entered(area):
	if state != State.ATTACK:
		return

	if area.is_in_group("PlayerHurtBox"):
		area.get_parent().hit(damage)
