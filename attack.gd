extends Node2D

signal attack_level_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_buy_button_down():
	var price = Data.attack_level_up_price()
	if (Data.gold >= price):
		Data.attack_level += 1
		Data.gold_use(price)
		attack_level_updated.emit()
