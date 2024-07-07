class_name Player

extends Area2D

const Actions = {ATTACK = 'attack', DEATH = 'death', IDLE = 'death', MOVE = 'move'}

@export var player_attack = 1

var action = Actions.MOVE
var currentEncounter: Mob = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar.max_value = Data.hp_value(Data.hp_level)
	$HealthBar.value = Data.current_hp

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
			attack(currentEncounter, player_attack)
	pass # Replace with function body.

func attack(target: Mob, damage: int = 1):
	target.take_damage(Data.attack_value(Data.attack_level))
