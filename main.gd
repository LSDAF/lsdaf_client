extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	var mobs = []
	
	for i in range(10):
		var mob  = mob_scene.instantiate()
		
		mob.position = $MobSpawner.position
		mob.position.x += i * 100
		mob.rotation = TAU
	
		add_child(mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
