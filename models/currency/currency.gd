class_name Currency

signal updated(new_value: int)

var _value: int = 0

func get_value():
	return _value
	
func update_value(delta: int):
	_value += delta
	updated.emit(_value)
