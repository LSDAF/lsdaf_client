class_name DifficultyService

var _difficulty_data: DifficultyData


func _init(difficulty_data: DifficultyData) -> void:
	_difficulty_data = difficulty_data


func set_current_difficulty(new_current_difficulty: float) -> void:
	_difficulty_data._current_difficulty = new_current_difficulty


func get_current_difficulty() -> float:
	return _difficulty_data._current_difficulty
