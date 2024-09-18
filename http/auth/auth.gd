class_name Auth

func login(email: String, password: String, on_success: Callable, on_failure: Callable, callback: Callable) -> LoginResponseDto:
	var body := JSON.stringify({
		"email": email,
		"password": password,
	})

	var response: HTTPResult = await Http.http.async_request(
		ApiRoutes.LOGIN,
		['Content-Type: application/json'],
		HTTPClient.METHOD_POST,
		body
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		return null

	print("Status code: ", response.status)
	print("Content-Type:", response.headers["content-type"])

	var json: Dictionary = response.body_as_json()

	if not json or not json['data']:
		push_error("JSON invalid.")
		return null

	return LoginResponseDto.new(json['data'])
