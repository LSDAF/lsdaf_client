extends ParallaxBackground

@export var sprite_height: float = 324
@export var viewport_height: float = 720

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scale_ratio: float = viewport_height / sprite_height
	scale = Vector2(scale_ratio, scale_ratio)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.scroll_offset.x -= delta * 100
