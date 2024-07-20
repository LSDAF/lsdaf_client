class_name Characteristic
extends Resource

signal upgraded

@export var name: String

var _level: int = 1

func next_level_cost() -> int:
	return 1

func current_value() -> int:
	return _level * 2
	
func get_level() -> int:
	return _level

func upgrade() -> void: 
	_level += 1
	upgraded.emit()
