extends VBoxContainer

@export var game_runtime_data: GameRuntimeData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_container_resized():
	game_runtime_data.set_game_node_position(%GameContainer.position)
	game_runtime_data.set_game_node_size(%GameContainer.size)
	pass # Replace with function body.
