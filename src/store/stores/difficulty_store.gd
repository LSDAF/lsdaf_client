class_name DifficultyStore extends ReactiveStore

# Type definitions
var gold: int:
	get:
		return _get_property(&"gold")
	set(v):
		set_property(&"gold", v)

var items: Array[String]:
	get:
		return _get_property(&"items")
	set(v):
		set_property(&"items", v)


func _init() -> void:
	_allowed_types = {&"gold": TYPE_INT, &"items": TYPE_ARRAY}

	_state = {"gold": 0, "items": []}

	# Computeds
	define_computed(&"total_items", func() -> int: return items.size())


# Actions
func add_gold(amount: int) -> void:
	gold += amount
