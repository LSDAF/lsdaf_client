extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Currencies.gold.updated.connect(_update_gold_value)
	_update_gold_value(Currencies.gold.get_value())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_gold_value(new_value: int):
	text = str(new_value)
