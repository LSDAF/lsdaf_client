class_name Currency

var _value: int = 0

func get_value():
	return _value
	
func update_value(delta: int):
	_value += delta
