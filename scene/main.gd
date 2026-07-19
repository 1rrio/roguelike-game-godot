extends Node2D

@onready var player = $Player
@onready var goblin = $Goblin
@onready var ui = $UI

func _ready():
	ui.set_player(player)
	ui.set_enemy(goblin)
