extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Access properties directly - initialization is handled internally
	print(Stores.difficulty.current_difficulty)  # Type-checked as float
	var a := Stores.difficulty.current_difficulty
