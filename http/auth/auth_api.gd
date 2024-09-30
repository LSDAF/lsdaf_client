class_name AuthApi


func login(email: String, password: String, on_failure: Callable) -> LoginResponseDto:
	var body: Dictionary = {
		"email": email,
		"password": password,
	}

	var response: HTTPResult = await Http.api_client.post(Http.api_routes.LOGIN, false, body)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return LoginResponseDto.new(json["data"])


func refresh_login(email: String, refresh_token: String, on_failure: Callable) -> LoginResponseDto:
	var body: Dictionary = {
		"email": email,
		"refresh_token": refresh_token,
	}

	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.REFRESH_LOGIN, false, body
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return LoginResponseDto.new(json["data"])


func register(
	name: String, email: String, password: String, on_failure: Callable
) -> RegisterResponseDto:
	var body: Dictionary = {
		"email": email,
		"password": password,
		"name": name,
	}

	var response: HTTPResult = await Http.api_client.post(Http.api_routes.REGISTER, false, body)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return RegisterResponseDto.new(json["data"])
