extends Node

class_name GameMain

signal on_logout


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Hud.on_logout.connect(_on_logout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logout() -> void:
	on_logout.emit()


func _on_game_save_timer_timeout() -> void:
	Services.game_save.save_game()
