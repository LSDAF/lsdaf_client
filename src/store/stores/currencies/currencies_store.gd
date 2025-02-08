class_name CurrenciesStore extends ReactiveStore

# Type definitions
var gold: int:
	get:
		return await _get_property(&"gold")
	set(v):
		set_property(&"gold", v)

var diamond: int:
	get:
		return await _get_property(&"diamond")
	set(v):
		set_property(&"diamond", v)

var emerald: int:
	get:
		return await _get_property(&"emerald")
	set(v):
		set_property(&"emerald", v)

var amethyst: int:
	get:
		return await _get_property(&"amethyst")
	set(v):
		set_property(&"amethyst", v)


func _init() -> void:
	_define_properties(
		{&"gold": TYPE_INT, &"diamond": TYPE_INT, &"emerald": TYPE_INT, &"amethyst": TYPE_INT},
		{&"gold": 0, &"diamond": 0, &"emerald": 0, &"amethyst": 0}
	)


# Actions
func set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	gold = _gold
	diamond = _diamond
	emerald = _emerald
	amethyst = _amethyst
