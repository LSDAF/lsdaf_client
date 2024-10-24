class_name DifficultyService


static func set_current_difficulty(new_current_difficulty: float) -> void:
	Data.difficulty._current_difficulty = new_current_difficulty


static func get_current_difficulty() -> float:
	return Data.difficulty._current_difficulty
