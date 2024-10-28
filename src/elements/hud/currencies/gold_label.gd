extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.currencies.gold.updated.connect(_update_gold_value)
	_update_gold_value(Data.currencies.gold.get_value())


func _update_gold_value(new_value: int) -> void:
	text = str(new_value)
