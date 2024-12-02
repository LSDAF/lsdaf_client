class_name GameMain
extends Node

signal on_logout


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Hud.on_logout.connect(_on_logout)


func _on_logout() -> void:
	on_logout.emit()


var lambda := func() -> void: Services.game_save.save_game()


func _on_game_save_timer_timeout() -> void:
	#	Services.game_save.save_game()
	var http_request: HttpEvent = HttpEvent.new(
		{"function": lambda, "nb_tries": 1, "prioritary": true}
	)
	Services.http_event_handler.enqueue_event(http_request)
	Services.http_event_handler.process_queue(false)
	Services.http_event_handler.process_queue(true)
