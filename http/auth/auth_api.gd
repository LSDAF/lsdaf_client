class_name AuthApi


func login(email: String, password: String, on_failure: Callable) -> LoginResponseDto:
	var body := (
		JSON
		. stringify(
			{
				"email": email,
				"password": password,
			}
		)
	)

	var response: HTTPResult = await Http.http.async_request(
		ApiRoutes.LOGIN, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body
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


func register(name: String, email: String, password: String, on_failure: Callable) -> RegisterResponseDto:
	var body := (
		JSON
		. stringify(
			{
				"email": email,
				"password": password,
				"name": name,
			}
		)
	)

	var response: HTTPResult = await Http.http.async_request(
		ApiRoutes.REGISTER, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body
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

	return RegisterResponseDto.new(json["data"])
