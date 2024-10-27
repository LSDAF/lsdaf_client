class_name Characteristic
extends Resource

signal upgraded

@export var name: String

@export var cost_scaler: CostScaler

var _level: int = 1


func next_level_cost() -> int:
	return cost_scaler.cost_from_level(_level)


func current_value() -> int:
	return _level * 2


func get_level() -> int:
	return _level


func upgrade() -> void:
	_level += 1
	upgraded.emit()
