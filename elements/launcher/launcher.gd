extends Control

class_name Launcher

signal game_loaded

@export var game_save_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LoginRegister.login_pressed.connect(login)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func login() -> void:
	var loginResponse: LoginResponseDto = await Api.auth.login("admin@admin.com", "admin", error)

	Api.access_token = loginResponse.access_token

	%LoginRegister.hide()
	%GameSavesCenterContainer.show()

	var game_saves: FetchGameSavesDto = await Api.user.fetch_game_saves(error)

	for game_save_dto in game_saves.game_saves:
		var game_save: GameSave = game_save_scene.instantiate()
		game_save.initialize(game_save_dto, _on_game_loaded)

		%GameSavesVBoxContainer.add_child(game_save)


func error(response: Variant) -> void:
	print("ERROR | ", response)


func _on_game_loaded() -> void:
	game_loaded.emit()


func _on_create_new_game_button_pressed() -> void:
	var game_save_dto: GameSaveDto = await Api.game_save.generate_game_save(error)

	var game_save: GameSave = game_save_scene.instantiate()
	game_save.initialize(game_save_dto, _on_game_loaded)

	%GameSavesVBoxContainer.add_child(game_save)
