class_name HttpEvent

var _function: Callable
var _nb_tries: int
var _prioritary: bool


func _init(dictionary: Dictionary) -> void:
	_function = dictionary["function"]
	_nb_tries = dictionary["nb_tries"]
	_prioritary = dictionary["prioritary"]


func to_dictionary() -> Dictionary:
	return {
		"function": _function,
		"nb_tries": _nb_tries,
		"prioritary": _prioritary,
	}


func get_function() -> Callable:
	return _function


func get_nb_tries() -> int:
	return _nb_tries


func get_prioritary() -> bool:
	return _prioritary
