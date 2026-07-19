extends Node2D

@export var max_hp := 10
@export var damage := 1
@export var parry_window := 0.15
@export var block_damage_multiplier := 0.3
var stamina: float
#stamina
@export var max_stamina := 100
@export var attack_cost := 20
@export var stamina_regen := 15.0

signal hp_changed(current_hp)
signal stamina_changed(current_stamina)
enum State {
	IDLE,
	LIGHT_ATTACK,
	PERFECT_BLOCK,
	BLOCK,
	HIT,
	STUN,
	DEAD
}

var state = State.IDLE
var hp: int
@onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var blockWindow: CollisionShape2D = $PlayerPerfectBlockWindow/CollisionShape2D

func _ready():
	hp = max_hp
	stamina = max_stamina
	sprite.play("idle")
	
	hp_changed.emit(hp)
	stamina_changed.emit(stamina)
	
func regen_stamina(delta):
	var old_stamina = stamina

	stamina = min(stamina + stamina_regen * delta, max_stamina)

	if stamina != old_stamina:
		stamina_changed.emit(stamina)
	
func use_stamina(cost: float) -> bool:
	if stamina < cost:
		return false

	stamina -= cost
	stamina_changed.emit(stamina)
	return true
	
func _process(delta):

	if Input.is_action_just_pressed("block"):
		if state != State.BLOCK and state != State.DEAD:
			block()
			return

	match state:
		State.IDLE:
			regen_stamina(delta)
			handle_idle()

		State.LIGHT_ATTACK:
			# boleh tambahkan logic attack di sini nanti
			pass
func handle_idle():
	if Input.is_action_just_pressed("light_attack"):
		if use_stamina(attack_cost):
			light_attack()
		else:
			print("Stamina tidak cukup")

	elif Input.is_action_just_pressed("block"):
		block()

func light_attack():
	state = State.LIGHT_ATTACK
	sprite.play("lightAttack1")
	hitbox.disabled = false
	
func block():
	if state == State.LIGHT_ATTACK:
		hitbox.disabled = true

	state = State.BLOCK
	blockWindow.disabled = false
	sprite.play("block")
	
func hit(dmg: int):
	if state == State.DEAD:
		return

	if state == State.BLOCK:
		dmg = max(1, int(round(dmg * block_damage_multiplier)))

	hp -= dmg
	hp = max(hp, 0)
	Debug.log("PLAYER", "Hit %d | HP %d/%d" % [dmg, hp, max_hp])
	hp_changed.emit(hp)

	if hp <= 0:
		die()
func die():
	if state == State.DEAD:
		return

	Debug.log("PLAYER", "Dead")

	state = State.DEAD
	hitbox.set_deferred("disabled", true)
	sprite.play("dead")
	
func _on_animated_sprite_2d_animation_finished():
	match state:
		State.LIGHT_ATTACK, State.BLOCK:
			state = State.IDLE
			sprite.play("idle")
			hitbox.disabled = true
			blockWindow.disabled = true

		State.DEAD:
			print("Game Over")
			# nanti bisa munculkan UI Game Over atau restart
			
func _on_hit_box_area_entered(area):
	if state == State.DEAD:
		return

	if area.is_in_group("HurtBox_Goblin"):
		area.get_parent().hit(damage)
