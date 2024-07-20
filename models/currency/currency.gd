class_name Currency

signal updated(new_value: int)

var _value: int = 0

func get_value() -> int:
	return _value
	
func update_value(delta: int) -> void:
	_value += delta
	updated.emit(_value)
