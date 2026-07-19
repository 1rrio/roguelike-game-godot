extends Node2D

@export var max_hp := 50
@export var damage := 10
signal hp_changed(current_hp)
var hp: int
var attack_timer := 0.0
@export var attack_delay := [
	0.8,
	1.2,
	1.8
]

enum State {
	IDLE,
	ATTACK,
	DEAD
}

var state = State.IDLE
@onready var hitbox: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var hurt_box: CollisionShape2D = $HurtBox/CollisionShape2D

func _process(delta):
	match state:
		State.IDLE:
			attack_timer -= delta

			if attack_timer <= 0:
				attack()
				
func _ready():
	hp = max_hp
	sprite.play("idle")
	hp_changed.emit(hp)
	attack_timer = attack_delay.pick_random()


func flash():
	sprite.modulate = Color(3, 3, 3)
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE
	
func attack():
	if state != State.IDLE:
		return

	state = State.ATTACK
	sprite.play("attack")
	$AnimationPlayer.play("attack")

	hitbox.disabled = false
func die():
	state = State.DEAD
	hurt_box.set_deferred("disabled", true)
	sprite.play("dead")
	
func hit(damage: int):
	if state == State.DEAD:
		return

	hp -= damage
	hp = max(hp, 0)
	Debug.log("GOBLIN", "Hit %d | HP %d/%d" % [damage, hp, max_hp])
	hp_changed.emit(hp)

	flash()

	if hp <= 0:
		die()
func _on_animated_sprite_2d_animation_finished():
	match state:
		State.ATTACK:
			state = State.IDLE
			sprite.play("idle")
			hitbox.disabled = true
			attack_timer = attack_delay.pick_random()

func _on_hit_box_area_entered(area):
	if state != State.ATTACK:
		return

	if area.is_in_group("PlayerHurtBox"):
		area.get_parent().hit(damage)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if state != State.ATTACK:
		return

	if area.is_in_group("PlayerHurtBox"):
		area.get_parent().hit(damage)
