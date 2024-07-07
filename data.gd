extends Node

signal gold_update

@export var attack_level := 1
@export var gold: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack_level_up_price():
	return attack_level + 1

func attack_value(level = 1):
	return level

func gold_add(income = 0):
	gold += income
	print('add')
	gold_update.emit()
	
func gold_use(cost = 0):
	gold -= cost
	print('use')
	gold_update.emit()
