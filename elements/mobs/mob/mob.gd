class_name Mob

extends Area2D

var BASE_SCALE = Vector2(0.5, 0.5)
var BASE_DAMAGE_LABEL_DISTANCE = 75

@export var damage_taken_label_scene: PackedScene

signal mob_death

var main = null

var max_health = 10
var health = 10
var gold_value = randi() % 10 + 1


# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node("Main")
	$AnimatedSprite2D.play("move")
	scale = BASE_SCALE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_areas = get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if (overlapping_area.position.x < position.x):
			return
			
	position.x -= 3
	
	$HealthBar.max_value = max_health

func take_damage(damage = 1):
	var damage_taken_label: DamageTakenLabel = damage_taken_label_scene.instantiate()
	damage_taken_label.text = str(damage)
	damage_taken_label.position.y -= BASE_DAMAGE_LABEL_DISTANCE * (1 / BASE_SCALE.y)
	
	add_child(damage_taken_label)
	
	health -= damage
	$HealthBar.value = health
	
	if (health <= 0):
		Currencies.gold.update_value(gold_value)
		mob_death.emit(self)
