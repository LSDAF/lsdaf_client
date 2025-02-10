class_name CurrenciesStore extends ReactiveStore

var gold_property := ReactiveStoreProperty.new(self, &"gold")
var diamond_property := ReactiveStoreProperty.new(self, &"diamond")
var emerald_property := ReactiveStoreProperty.new(self, &"emerald")
var amethyst_property := ReactiveStoreProperty.new(self, &"amethyst")

# Type definitions
var gold: int:
	get:
		return await gold_property.get_value()
	set(v):
		gold_property.set_value(v)

var diamond: int:
	get:
		return await diamond_property.get_value()
	set(v):
		diamond_property.set_value(v)

var emerald: int:
	get:
		return await emerald_property.get_value()
	set(v):
		emerald_property.set_value(v)

var amethyst: int:
	get:
		return await amethyst_property.get_value()
	set(v):
		amethyst_property.set_value(v)


func _init() -> void:
	_initialize_reactive_store(
		CurrenciesState.get_property_types(), CurrenciesState.get_initial_state()
	)


# Actions
func set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	set_properties(
		{&"gold": _gold, &"diamond": _diamond, &"emerald": _emerald, &"amethyst": _amethyst}
	)
