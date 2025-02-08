extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get a store with type hinting
	var difficulty: DifficultyStore = Stores.get_store(&"Difficulty") as DifficultyStore

	# Access properties safely
	print(difficulty.gold)  # Type-checked as int
	var a := difficulty.gold
