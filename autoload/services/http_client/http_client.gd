extends Node

var _app_config: AppConfig
var _access_token: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_app_config = load("res://resources/properties/app_config.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func user_token() -> String:
	return _access_token


static func build_login_user_request(email: String, password: String) -> String:
	var request: String = JSON.stringify({"email": email, "password": password})

	return request


func _on_login_user_success(
	result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray
) -> void:
#	print("result:" + str(result))
#	print("response_code:" + str(response_code))
#	print("headers:" + str(headers))

	var json: Variant = JSON.parse_string(body.get_string_from_utf8())
#	print("body:" + str(json))

	if json and json["data"]["access_token"]:
		_access_token = json["data"]["access_token"]


func login_user(email: String, password: String) -> Signal:
	# Create an HTTP request node and connect its completion signal.
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_login_user_success)
	var payload := build_login_user_request(email, password)

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.

	var url := _app_config.backend_url + ":" + _app_config.port + "/api/v1/auth/login"

	var error := http_request.request(
		url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, payload
	)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

	return http_request.request_completed


func register_user() -> void:
	pass


func me() -> void:
	pass


func get_game_save() -> void:
	pass


func _on_generate_game_save_success(
	result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray
) -> void:
#	print("result:" + str(result))
	print("_on_generate_game_save_success | response_code:" + str(response_code))
#	print("headers:" + str(headers))

	var json: Variant = JSON.parse_string(body.get_string_from_utf8())
#	print("body:" + str(json))


func generate_game_save() -> Signal:
	# Create an HTTP request node and connect its completion signal.
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_generate_game_save_success)

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.

	var url := _app_config.backend_url + ":" + _app_config.port + "/api/v1/game_save/generate"

	print("generate_game_save | access_token " + _access_token)

	var error := http_request.request(
		url,
		["Content-Type: application/json", "Authorization: Bearer " + _access_token],
		HTTPClient.METHOD_POST
	)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

	return http_request.request_completed


func update_game_save() -> void:
	pass
