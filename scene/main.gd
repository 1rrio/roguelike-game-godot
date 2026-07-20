extends Node2D
@onready var skeleton = $MonsterSpawner/Marker2D/Enemies/Skeleton
@onready var player = $Player
@onready var goblin = $MonsterSpawner/Marker2D/Enemies/Goblin
@onready var ui = $UI

func _ready():
	ui.set_player(player)
	ui.set_enemy(goblin)
