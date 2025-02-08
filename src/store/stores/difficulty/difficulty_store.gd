class_name DifficultyStore extends ReactiveStore

# Type definitions
var current_difficulty: float:
	get:
		return _get_property(&"current_difficulty")
	set(v):
		set_property(&"current_difficulty", v)


func _init() -> void:
	_allowed_types = {&"current_difficulty": TYPE_FLOAT}
	_state = {"current_difficulty": 1.0}


# Actions
func set_current_difficulty(new_difficulty: float) -> void:
	current_difficulty = new_difficulty
