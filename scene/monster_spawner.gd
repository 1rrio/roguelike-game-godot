extends Node2D

@onready var goblin = $Marker2D/Enemies/Goblin
@onready var skeleton = $Marker2D/Enemies/Skeleton
@onready var ui = $"../UI"
func _ready():
	skeleton.deactivate()
	goblin.reset_enemy()
	ui.set_enemy(goblin)
	goblin.died.connect(_on_goblin_dead)
	skeleton.died.connect(_on_skeleton_dead)

func _on_goblin_dead():
	goblin.deactivate()
	skeleton.reset_enemy()

	ui.set_enemy(skeleton)

func _on_skeleton_dead():
	skeleton.deactivate()
	goblin.reset_enemy()

	ui.set_enemy(goblin)
