extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Currencies.amethyst.updated.connect(_update_amethyst_value)
	_update_amethyst_value(Currencies.amethyst.get_value())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_amethyst_value(new_value: int) -> void:
	text = str(new_value)
