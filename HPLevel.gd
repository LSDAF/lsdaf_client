extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Level: " + str(Data.hp_level)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hp_hp_level_updated():
	text = "Level: " + str(Data.hp_level)
