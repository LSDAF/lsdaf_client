class_name DifficultyState extends BaseState


static func get_property_types() -> Dictionary:
	return {&"current_difficulty": TYPE_FLOAT}


static func get_initial_state() -> Dictionary:
	return {&"current_difficulty": 1.0}
