extends CanvasLayer

@onready var hp_bar = $Control/HPBar
@onready var stamina_bar = $Control/StaminaBar
@onready var enemy_bar: ProgressBar = $Control/EnemyBar
@onready var hp_bar_back: ProgressBar = $Control/HPBar/HpBarBack
@onready var enemy_bar_back: ProgressBar = $Control/EnemyBar/EnemyBarBack
@onready var hp_player: Label = $Control/HpPlayer
@onready var hp_enemy: Label = $Control/HpEnemy


var current_enemy = null

func set_enemy(enemy):
	if current_enemy != null:
		if current_enemy.hp_changed.is_connected(update_enemy_hp):
			current_enemy.hp_changed.disconnect(update_enemy_hp)

	current_enemy = enemy

	enemy_bar.max_value = enemy.max_hp
	enemy_bar.value = enemy.hp
	enemy_bar_back.max_value = enemy.max_hp
	enemy_bar_back.value = enemy.hp

	hp_enemy.text = "%d / %d" % [enemy.hp, enemy.max_hp]

	enemy.hp_changed.connect(update_enemy_hp)
	
func update_enemy_hp(value):
	hp_enemy.text = "%d / %d" % [value, enemy_bar.max_value]

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(enemy_bar_back, "value", value, 0.2)
	tween.tween_property(enemy_bar, "value", value, 1)
	
func set_player(player):
	hp_bar.max_value = player.max_hp
	hp_bar.value = player.hp
	hp_bar_back.max_value = player.max_hp
	hp_bar_back.value = player.hp

	stamina_bar.max_value = player.max_stamina
	stamina_bar.value = player.stamina

	hp_player.text = "%d / %d" % [player.hp, player.max_hp]

	player.hp_changed.connect(update_hp)
	player.stamina_changed.connect(update_stamina)
	
func update_hp(value):
	hp_player.text = "%d / %d" % [value, hp_bar.max_value]

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hp_bar_back, "value", value, 0.2)
	tween.tween_property(hp_bar, "value", value, 1)
	
func update_stamina(value):
	stamina_bar.value = value
