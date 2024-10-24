extends Control

class_name Launcher

signal game_loaded

@export var game_save_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LoginRegister.on_login.connect(login)

	if await Services.user_local_data.relog_user() == true:
		fetch_game_saves()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func fetch_game_saves() -> void:
	%LoginRegister.hide()
	%GameSavesCenterContainer.show()

	var game_saves: FetchGameSavesDto = await UserApi.fetch_game_saves(_on_fetch_game_saves_error)

	for game_save_dto in game_saves.game_saves:
		var game_save: GameSaveButton = game_save_scene.instantiate()
		game_save.initialize(game_save_dto, _on_game_loaded)

		%GameSavesVBoxContainer.add_child(game_save)


func login(email: String, password: String) -> void:
	var loginResponse: LoginResponseDto = await AuthApi.login(email, password, _on_login_error)

	if loginResponse == null:
		return

	Services.user_local_data.save_access_token(loginResponse.access_token)
	Services.user_local_data.save_refresh_token(loginResponse.refresh_token)

	fetch_game_saves()


func return_to_login_form() -> void:
	%LoginRegister.show()
	%GameSavesCenterContainer.hide()

	for child in %GameSavesVBoxContainer.get_children():
		child.queue_free()


func _on_generate_game_save_error(response: Variant) -> void:
	Services.toaster.toast("Error when generating save")


func _on_login_error(response: Variant) -> void:
	Services.toaster.toast("Error when logging in")


func _on_fetch_game_saves_error(response: Variant) -> void:
	Services.toaster.toast("Error when fetching games")

	Services.user_local_data.create_new_user_data()
	return_to_login_form()


func _on_game_loaded() -> void:
	game_loaded.emit()


func _on_create_new_game_button_pressed() -> void:
	var game_save_dto: GameSaveDto = await GameSaveApi.generate_game_save(
		_on_generate_game_save_error
	)

	var game_save: GameSaveButton = game_save_scene.instantiate()
	game_save.initialize(game_save_dto, _on_game_loaded)

	%GameSavesVBoxContainer.add_child(game_save)
