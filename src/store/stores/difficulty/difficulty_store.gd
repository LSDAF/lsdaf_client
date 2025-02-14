class_name DifficultyStore extends ReactiveStore

var current_difficulty_property := ReactiveStoreProperty.new(self, &"current_difficulty"):
	set(_value):
		push_error(
			"current_difficulty_property cannot be reassigned. Use actions to modify the value."
		)


func _init() -> void:
	_initialize_reactive_store(
		DifficultyState.get_property_types(), DifficultyState.get_initial_state()
	)


# Actions
func set_current_difficulty(new_difficulty: float) -> void:
	set_properties({&"current_difficulty": new_difficulty})
