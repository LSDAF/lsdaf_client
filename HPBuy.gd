extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Cost: " + str(Data.hp_level_up_price())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_attack_level_updated():
	text = "Cost: " + str(Data.hp_level_up_price())
