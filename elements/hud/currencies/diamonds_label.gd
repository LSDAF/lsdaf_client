extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Currencies.diamond.updated.connect(_update_diamond_value)
	_update_diamond_value(Currencies.diamond.get_value())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_diamond_value(new_value: int) -> void:
	text = str(new_value)
