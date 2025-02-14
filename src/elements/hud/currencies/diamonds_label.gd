extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Services.currencies.connect_diamond_updated(_update_diamond_value)
	_update_diamond_value(Services.currencies.get_diamond_value())


func _update_diamond_value(new_value: int) -> void:
	text = str(new_value)
