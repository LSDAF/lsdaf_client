class_name CharacteristicsState extends BaseState


static func get_property_types() -> Dictionary:
	return {
		&"attack": TYPE_OBJECT,
		&"crit_chance": TYPE_OBJECT,
		&"crit_damage": TYPE_OBJECT,
		&"health": TYPE_OBJECT,
		&"resistance": TYPE_OBJECT
	}


static func get_initial_state() -> Dictionary:
	return {
		&"attack": preload("res://src/resources/characteristics/attack.tres"),
		&"crit_chance": preload("res://src/resources/characteristics/crit_chance.tres"),
		&"crit_damage": preload("res://src/resources/characteristics/crit_damage.tres"),
		&"health": preload("res://src/resources/characteristics/health.tres"),
		&"resistance": preload("res://src/resources/characteristics/resistance.tres")
	}
