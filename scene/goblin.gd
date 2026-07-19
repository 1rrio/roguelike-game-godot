extends Node2D

@export var max_hp := 50
@export var damage := 10
var hp: int


enum State {
	IDLE,
	HIT,
	ATTACK,
	DEAD
}
var hit_count = 0
var state = State.IDLE

@onready var sprite = $AnimatedSprite2D
@onready var hurt_box: CollisionShape2D = $HurtBox/CollisionShape2D


func _ready():
	hp = max_hp
	sprite.play("idle")
	

	
func die():
	state = State.DEAD
	hurt_box.set_deferred("disabled", true)
	sprite.play("dead")
	
func hit(damage: int):
	if state == State.DEAD:
		return
	hp -= damage
	if hp <= 0:
		debug()
		die()
		return
	
	state = State.HIT
	debug()
	sprite.play("hit")
		
func _on_animated_sprite_2d_animation_finished():
	match state:
		State.HIT:
			state = State.IDLE
			sprite.play("idle")
			hurt_box.set_deferred("disabled", false)

func _on_hurt_box_area_entered(area) -> void:
	if area.is_in_group("PlayerHitBox"):
		pass

func debug():
		#debug
	hit_count += 1
	print("====ENEMY====")
	print("Goblin get Hit by PLayer "  , hit_count)
	print("HP :", hp, "/", max_hp)
	print("=============\n")
