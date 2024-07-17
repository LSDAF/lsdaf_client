extends Control

@export var game_runtime_data: GameRuntimeData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_container_resized():
	game_runtime_data.set_game_node_position(%GameContainer.position)
	# TODO: No magic number ! Comes from the mirroring of the parralax layers, which come from the size of the sprite (texture)
	var new_scale = %GameContainer.size.x / 576
	game_runtime_data.set_game_node_scale(Vector2(new_scale, new_scale))
	pass # Replace with function body.
