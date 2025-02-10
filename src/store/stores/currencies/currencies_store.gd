class_name CurrenciesStore extends ReactiveStore

var gold_property := ReactiveStoreProperty.new(self, &"gold"):
	set(_value):
		push_error("gold_property cannot be reassigned. Use actions to modify the value.")

var diamond_property := ReactiveStoreProperty.new(self, &"diamond"):
	set(_value):
		push_error("diamond_property cannot be reassigned. Use actions to modify the value.")

var emerald_property := ReactiveStoreProperty.new(self, &"emerald"):
	set(_value):
		push_error("emerald_property cannot be reassigned. Use actions to modify the value.")

var amethyst_property := ReactiveStoreProperty.new(self, &"amethyst"):
	set(_value):
		push_error("amethyst_property cannot be reassigned. Use actions to modify the value.")


func _init() -> void:
	_initialize_reactive_store(
		CurrenciesState.get_property_types(), CurrenciesState.get_initial_state()
	)


# Actions
func set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	set_properties(
		{&"gold": _gold, &"diamond": _diamond, &"emerald": _emerald, &"amethyst": _amethyst}
	)
