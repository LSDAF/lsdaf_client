extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.currencies.diamond.updated.connect(_update_diamond_value)
	_update_diamond_value(Data.currencies.diamond.get_value())


func _update_diamond_value(new_value: int) -> void:
	text = str(new_value)
