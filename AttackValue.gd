extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(Data.attack_value(Data.attack_level)) + " -> " + str(Data.attack_value(Data.attack_level + 1)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_attack_level_updated():
	text = str(Data.attack_value(Data.attack_level)) + " -> " + str(Data.attack_value(Data.attack_level + 1)) 
