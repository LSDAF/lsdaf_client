class_name Player

extends Area2D

const Actions = {ATTACK = 'attack', DEATH = 'death', IDLE = 'death', MOVE = 'move'}

var current_hp: int = Characteristics.hp.current_value()
var action := Actions.MOVE
var currentEncounter: Mob = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar.max_value = Characteristics.hp.current_value()
	$HealthBar.value = current_hp

func _on_area_entered(area):
	currentEncounter = area
	action = Actions.ATTACK
	$AnimatedSprite2D.play(action)

func _on_area_exited(area):
	currentEncounter = null
	action = Actions.MOVE
	$AnimatedSprite2D.play(action)

func _on_animated_sprite_2d_frame_changed():
	if ($AnimatedSprite2D.animation == Actions.ATTACK and $AnimatedSprite2D.frame == 1):
		if (currentEncounter != null):
			attack(currentEncounter)
	pass # Replace with function body.

func attack(target: Mob):
	target.take_damage(Characteristics.attack.current_value())