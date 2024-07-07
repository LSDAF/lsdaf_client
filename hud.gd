extends CanvasLayer

signal gold_update

var data

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.gold_update.connect(_on_data_gold_update)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _on_data_gold_update():
	gold_update.emit()
