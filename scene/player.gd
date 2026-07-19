extends Node2D

@export var max_hp := 10
@export var damage := 1
@export var parry_window := 0.15

enum State {
	IDLE,
	LIGHT_ATTACK,
	HEAVY_ATTACK,
	PARRY,
	HIT,
	DEAD
}
var hit_count = 0
var state = State.IDLE
var hp: int
@onready var Hitbox: CollisionShape2D = $HitBox/CollisionShape2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	hp = max_hp
	sprite.play("idle")

func _process(_delta):
	match state:
		State.IDLE:
			handle_idle()

func handle_idle():
	if Input.is_action_just_pressed("light_attack"):
		light_attack()

	elif Input.is_action_just_pressed("parry"):
		parry()

func light_attack():
	state = State.LIGHT_ATTACK
	sprite.play("lightAttack1")
	Hitbox.disabled = false
func heavy_attack():
	state = State.HEAVY_ATTACK
	sprite.play("heavyAttack")
	Hitbox.disabled = false
func parry():
	state = State.PARRY
	sprite.play("parry")

func _on_animated_sprite_2d_animation_finished():
	match state:
		State.LIGHT_ATTACK, State.HEAVY_ATTACK, State.PARRY:
			state = State.IDLE
			sprite.play("idle")
			Hitbox.disabled = true
			
func _on_hit_box_area_entered(area) -> void:
	if area.is_in_group("HurtBox_Goblin"):
		area.get_parent().hit(damage)
		#debug
		hit_count += 1
		print("====PLAYER====")
		print("player ", area.get_groups(), "Hit ", hit_count)
		print("HP :", hp, "/", max_hp)
		print("=============\n")
