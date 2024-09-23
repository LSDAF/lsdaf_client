extends Control

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

	for game_save in game_saves.game_saves:
		var game_save_node: GameSaveNode = game_save_scene.instantiate()
		game_save_node.initialize(
			game_save.id,
			game_save.gold,
			game_save.created_at
		)
		
		%GameSavesVBoxContainer.add_child(game_save_node)
		

func callback(response: Variant) -> void:
	print("CALLBACK | ", response)

func error(response: Variant) -> void:
#	var json_http_response: JsonHttpResponse = response
	print("ERROR | ", response)

func generate_game_save(response: Variant) -> void:
#	await ApiClient.generate_game_save()
	print("GEN GAME SAVE |", response)


func _on_create_new_game_button_pressed() -> void:
	var game_save: GameSaveDto = await Api.game_save.generate_game_save(error)

	var game_save_node: GameSaveNode = game_save_scene.instantiate()
	game_save_node.initialize(
		game_save.id,
		game_save.gold,
		game_save.created_at
	)
	
	%GameSavesVBoxContainer.add_child(game_save_node)
