extends Node

var _app_config: AppConfig
var _access_token: String

# Called when the node enters the scene tree for the first time.
func _ready():
	_app_config = load("res://resources/properties/app_config.tres")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print('result:' + str(result))
	print('response_code:' + str(response_code))
	print('headers:' + str(headers))
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	print('body:' + str(json))
	
	_access_token = json["data"]["access_token"]

func user_token():
	return _access_token

static func build_login_user_request(email: String, password: String) -> String:
	var request = JSON.stringify(
		{
			"email": email,
			"password": password
		})
	
	return request

func login_user(email: String, password: String):
	print('login')
	
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)
	var payload = build_login_user_request(email, password)
	
	# Perform a GET request. The URL below returns JSON as of writing.
	#var error = http_request.request("https://httpbin.org/get")
	#if error != OK:
	#	push_error("An error occurred in the HTTP request.")

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.
		
	var url = _app_config.backend_url + ':' + _app_config.port + '/api/v1/auth/login'
		
	var error = http_request.request(url, ['Content-Type: application/json'], HTTPClient.METHOD_POST, payload)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	

func register_user():
	pass
	

func me():
	pass
	
func get_game_save():
	pass
	
func update_game_save():
	pass
