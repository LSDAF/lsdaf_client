extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.currencies.amethyst.updated.connect(_update_amethyst_value)
	_update_amethyst_value(Data.currencies.amethyst.get_value())


func _update_amethyst_value(new_value: int) -> void:
	text = str(new_value)
