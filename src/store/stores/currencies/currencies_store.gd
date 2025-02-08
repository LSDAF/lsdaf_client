class_name CurrenciesStore extends ReactiveStore

# Type definitions
var gold: int:
	get:
		return _get_property(&"gold")
	set(v):
		set_property(&"gold", v)

var diamond: int:
	get:
		return _get_property(&"diamond")
	set(v):
		set_property(&"diamond", v)

var emerald: int:
	get:
		return _get_property(&"emerald")
	set(v):
		set_property(&"emerald", v)

var amethyst: int:
	get:
		return _get_property(&"amethyst")
	set(v):
		set_property(&"amethyst", v)


func _init() -> void:
	_allowed_types = {
		&"gold": TYPE_INT, &"diamond": TYPE_INT, &"emerald": TYPE_INT, &"amethyst": TYPE_INT
	}
	_state = {"gold": 0, "diamond": 0, "emerald": 0, "amethyst": 0}


# Actions
func set_currencies(
	gold_value: int, diamond_value: int, emerald_value: int, amethyst_value: int
) -> void:
	gold = gold_value
	diamond = diamond_value
	emerald = emerald_value
	amethyst = amethyst_value
