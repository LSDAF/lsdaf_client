class_name HttpEvent

var _function: Callable
var _nb_retries: int
var _prioritary: bool


func _init(dictionary: Dictionary) -> void:
	_function = dictionary["function"]
	_nb_retries = dictionary["nb_retries"]
	_prioritary = dictionary["prioritary"]


func to_dictionary() -> Dictionary:
	return {
		"function": _function,
		"nb_retries": _nb_retries,
		"prioritary": _prioritary,
	}


func get_function() -> Callable:
	return _function


func get_nb_retries() -> int:
	return _nb_retries


func get_prioritary() -> bool:
	return _prioritary
