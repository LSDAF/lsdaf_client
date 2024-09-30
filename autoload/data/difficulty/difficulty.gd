extends Node

class_name Difficulty
	
var _current_difficulty := 1.0


func set_current_difficulty(new_difficulty: float) -> void:
	_current_difficulty = new_difficulty


func get_current_difficulty() -> float:
	return _current_difficulty
