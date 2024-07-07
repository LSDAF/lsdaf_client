class_name Mob

extends Area2D

@export var damage_taken_label_scene: PackedScene
@export var on_kill_callback: Callable

var main = null

var max_health = 10
var health = 10
var gold_value = randi() % 10 + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node("Main")
	$AnimatedSprite2D.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_areas = get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if (overlapping_area.position.x < position.x):
			return
			
	position.x -= 1
	
	$HealthBar.max_value = max_health

func take_damage(damage = 1):
	var damage_taken_label: DamageTakenLabel = damage_taken_label_scene.instantiate()
	damage_taken_label.text = str(damage)
	damage_taken_label.position.y -= 65
	
	add_child(damage_taken_label)
	
	health -= damage
	$HealthBar.value = health
	
	if (health <= 0):
		on_kill_callback.call(gold_value)
		queue_free()
