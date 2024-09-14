extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	login()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func login() -> void:
	await HttpClient.login_user("admin@admin.com", "admin")
	await HttpClient.generate_game_save()
