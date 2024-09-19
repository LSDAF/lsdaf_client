extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func login() -> void:
	var loginResponse: LoginResponseDto = await Api.auth.login("admin@admin.com", "admin", error)
	print('TOKEN: ', loginResponse.access_token)

	Api.access_token = loginResponse.access_token

	%LoginRegisterMarginContainer.hide()
	%GameSavesCenterContainer.show()

	await Api.user.fetch_game_saves(error)
	
func callback(response: Variant) -> void:
	print("CALLBACK | ", response)

func error(response: Variant) -> void:
#	var json_http_response: JsonHttpResponse = response
	print("ERROR | ", response)

func generate_game_save(response: Variant) -> void:
#	await ApiClient.generate_game_save()
	print("GEN GAME SAVE |", response)


func _on_login_button_pressed() -> void:
	login()
