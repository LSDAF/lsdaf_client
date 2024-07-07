extends Node

signal gold_update
signal spawn_mobs

@export var attack_level := 1
@export var gold: int = 0
@export var current_mobs: Array[Mob] = []

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
	gold_update.emit()
	
func gold_use(cost = 0):
	gold -= cost
	gold_update.emit()

func on_mob_death(mob: Mob):
	print('mob death')
	print(current_mobs)
	mob.queue_free()
	var mob_index = current_mobs.find(mob)
	current_mobs.remove_at(mob_index)
	
	if (current_mobs.size() < 1):
		spawn_mobs.emit()
