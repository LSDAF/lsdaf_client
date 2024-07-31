extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: handle async
	await HttpClient.login_user("toto@toto.fr", "k127F978")
	await HttpClient.generate_game_save()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
