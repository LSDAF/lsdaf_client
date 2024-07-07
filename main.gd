extends Node

class_name Main

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_mobs():
	var mobs: Array[Mob] = []
	
	for i in range(10):
		var mob  = mob_scene.instantiate()
		
		mob.position = $MobSpawner.position
		mob.position.x += i * 100
		mob.rotation = TAU
		
		mob.mob_death.connect(Data.on_mob_death)
		
		mobs.push_back(mob)
		
	return mobs

func instanciate_mobs(mobs: Array[Mob]):
	for i in range(mobs.size()):
		call_deferred('add_child', mobs[i])
	
