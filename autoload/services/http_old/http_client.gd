extends Node

class_name HttpClient

const APP_URL: String = "http://localhost"
const APP_PORT: int = 8080

const ERROR: int = 1
const OK: int = 0

var _error := ""
var _response := ""

var client: HTTPClient = HTTPClient.new()


# GET, but the get function name is reserved
func fetch(uri: String, access_token: String = "") -> Variant:
	return _request(HTTPClient.METHOD_GET, uri, "", access_token)


# TODO, form encode collections if desired
func post(uri: String, body: Variant, access_token: String = "") -> Variant:
	return _request(HTTPClient.METHOD_POST, uri, body, access_token)


func put(uri: String, body: Variant, access_token: String = "") -> Variant:
	return _request(HTTPClient.METHOD_PUT, uri, body, access_token)


func delete(uri: String, access_token: String = "") -> Variant:
	return _request(HTTPClient.METHOD_DELETE, uri, "", access_token)


func _request(
	method: HTTPClient.Method, uri: String, body: Variant, access_token: String = ""
) -> Variant:
	_response = ""
	var url := APP_URL + ":" + str(APP_PORT) + uri
	var headers := ["User-Agent: godot game engine", "Content-Type: application/json"]

	if access_token != "":
		headers.append("Authorization: Bearer {0}".format([access_token]))

	print(headers)

	var res := _connect()
	if res == ERROR:
		return _getErr()
	else:
		client.request(method, url, headers, body)
	# TODO, Content-Type and other headers

	res = _poll()
	if res != OK:
		return _getErr()

	client.close()
	return _response


func _connect() -> int:
	client.connect_to_host(APP_URL, APP_PORT)
	var res := _poll()
	if res != OK:
		return ERROR
	return OK


func _getErr() -> String:
	return _error


func _setError(msg: String) -> int:
	_error = str(msg)
	return ERROR


func _poll() -> int:
	var status := -1
	var current_status: int
	while true:
		client.poll()
		current_status = client.get_status()
		if status != current_status:
			status = current_status
			print("HTTPClient entered status ", status)
			if status == HTTPClient.STATUS_RESOLVING:
				continue
			if status == HTTPClient.STATUS_REQUESTING:
				continue
			if status == HTTPClient.STATUS_CONNECTING:
				continue
			if status == HTTPClient.STATUS_CONNECTED:
				return OK
			if status == HTTPClient.STATUS_DISCONNECTED:
				return _setError("Disconnected from Host")
			if status == HTTPClient.STATUS_CANT_RESOLVE:
				return _setError("Can't Resolve Host")
			if status == HTTPClient.STATUS_CANT_CONNECT:
				return _setError("Can't Connect to Host")
			if status == HTTPClient.STATUS_CONNECTION_ERROR:
				return _setError("Connection Error")
			if status == HTTPClient.STATUS_BODY:
				return _parseBody()

	# This line should never be reached
	return ERROR


func _parseBody() -> int:
	_response = client.read_response_body_chunk().get_string_from_ascii()
	var response_code := client.get_response_code()
	if response_code >= 200 && response_code < 300:
		return OK

	if response_code >= 400:
		return _setError("HTTP:" + str(response_code))
	return OK
