extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func login() -> void:
	Api.auth.login("admin@admin.com", "admin", generate_game_save, error, callback)
#	await ApiClient.login_user("admin@admin.com", "admin")

#	var response := await ApiClient.get_game_save()
#	print(response)

	%LoginRegisterMarginContainer.hide()
	%GameSavesCenterContainer.show()

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
