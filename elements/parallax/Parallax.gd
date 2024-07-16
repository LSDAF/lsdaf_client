extends ParallaxBackground

@export var game_runtime_data: GameRuntimeData

# Called when the node enters the scene tree for the first time.
func _ready():
	game_runtime_data.game_node_position_changed.connect(update_position)
	game_runtime_data.game_node_size_changed.connect(update_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scroll_offset.x -= delta * 100

# TODO: Penser au Mirroring qui est dans les ParralaxLayer

func update_position(new_position: Vector2):
	offset = new_position
	
func update_size(new_size: Vector2):
	# TODO: No magic number ! Comes from the mirroring of the parralax layers, which come from the size of the sprite (texture)
	var new_scale = new_size.x / 576
	scale.x = new_scale
	scale.y = new_scale
