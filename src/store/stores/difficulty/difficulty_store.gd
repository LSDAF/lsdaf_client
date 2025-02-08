class_name DifficultyStore extends ReactiveStore

# Type definitions
var current_difficulty: float:
	get:
		return await _get_property(&"current_difficulty")
	set(v):
		set_property(&"current_difficulty", v)


func _init() -> void:
	_define_properties({&"current_difficulty": TYPE_FLOAT}, {&"current_difficulty": 1.0})


func _inject_dependencies(_stores: Dictionary) -> void:
	_dependencies_injected = true


# Actions
func set_current_difficulty(new_difficulty: float) -> void:
	current_difficulty = new_difficulty
