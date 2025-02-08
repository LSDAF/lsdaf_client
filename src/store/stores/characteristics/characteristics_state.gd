class_name CharacteristicsState extends BaseState


static func get_property_types() -> Dictionary:
	return {
		&"attack": TYPE_INT,
		&"crit_chance": TYPE_INT,
		&"crit_damage": TYPE_INT,
		&"health": TYPE_INT,
		&"resistance": TYPE_INT
	}


static func get_initial_state() -> Dictionary:
	return {&"attack": 0, &"crit_chance": 0, &"crit_damage": 0, &"health": 0, &"resistance": 0}
