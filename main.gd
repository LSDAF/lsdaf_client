extends Node

@export var mob_scene: PackedScene

var gold: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	var mobs = []
	
	for i in range(10):
		var mob = mob_scene.instantiate()
		mob.on_kill_callback = add_gold
		
		mob.position = $MobSpawner.position
		mob.position.x += i * 100
		mob.rotation = TAU
	
		add_child(mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_gold(income: int = 1):
	gold += income
	$GoldLabel.text = str(gold)
