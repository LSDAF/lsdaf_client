class_name StageState extends BaseState


static func get_property_types() -> Dictionary:
	return {
		&"current_stage": TYPE_INT,
		&"current_wave": TYPE_INT,
		&"max_stage": TYPE_INT,
		&"max_wave": TYPE_INT,
		&"is_boss_wave": TYPE_BOOL
	}


static func get_initial_state() -> Dictionary:
	return {&"current_stage": 1, &"current_wave": 1, &"max_stage": 1, &"max_wave": 3}
