class_name CurrenciesState extends BaseState


static func get_property_types() -> Dictionary:
	return {&"gold": TYPE_INT, &"diamond": TYPE_INT, &"emerald": TYPE_INT, &"amethyst": TYPE_INT}


static func get_initial_state() -> Dictionary:
	return {&"gold": 0, &"diamond": 0, &"emerald": 0, &"amethyst": 0}
