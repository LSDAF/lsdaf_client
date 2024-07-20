extends Node

var _current_difficulty: float

func set_current_difficulty(new_difficulty: float) -> void:
	_current_difficulty = new_difficulty
	
func get_current_difficulty() -> float:
	return _current_difficulty
