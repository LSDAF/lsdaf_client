extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(Data.hp_value(Data.hp_level)) + " -> " + str(Data.hp_value(Data.hp_level + 1)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hp_hp_level_updated():
	text = str(Data.hp_value(Data.hp_level)) + " -> " + str(Data.hp_value(Data.hp_level + 1)) 
