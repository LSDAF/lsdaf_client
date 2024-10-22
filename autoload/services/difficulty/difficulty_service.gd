class_name DifficultyService


func set_current_difficulty(new_current_difficulty: float) -> void:
	Data.difficulty._current_difficulty = new_current_difficulty


func get_current_difficulty() -> float:
	return Data.difficulty._current_difficulty
