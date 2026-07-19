extends CanvasLayer

@onready var hp_bar = $Control/HPBar
@onready var stamina_bar = $Control/StaminaBar
@onready var enemy_bar: ProgressBar = $Control/EnemyBar

func set_enemy(enemy):
	enemy_bar.max_value = enemy.max_hp
	enemy_bar.value = enemy.hp

	enemy.hp_changed.connect(update_enemy_hp)

func update_enemy_hp(value):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(enemy_bar, "value", value, 0.2)
	
func set_player(player):

	hp_bar.max_value = player.max_hp
	stamina_bar.max_value = player.max_stamina

	player.hp_changed.connect(update_hp)
	player.stamina_changed.connect(update_stamina)

func update_hp(value):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hp_bar, "value", value, 0.2)

func update_stamina(value):
	stamina_bar.value = value
