class_name Characteristic
extends Resource

signal upgraded

@export var name: String

# From this idea https://stackoverflow.com/questions/76700683/what-formulas-to-use-for-clicker-incremental-games
@export var cost_exponent: float
@export var cost_coef: float
@export var cost_base: int

var _level: int = 1

func next_level_cost() -> int:
	return cost_coef * (_level ** cost_exponent) + cost_base

func current_value() -> int:
	return _level * 2
	
func get_level() -> int:
	return _level

func upgrade() -> void: 
	_level += 1
	upgraded.emit()
