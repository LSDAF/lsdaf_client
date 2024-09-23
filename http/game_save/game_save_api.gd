class_name GameSaveApi


func generate_game_save(on_failure: Callable) -> GameSaveDto:
	var response: HTTPResult = await (
		Http
		. http
		. async_request(
			ApiRoutes.GENERATE_GAME_SAVE,
			["Authorization: Bearer {0}".format([Api.access_token])],
			HTTPClient.METHOD_POST,
		)
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		return null

	return GameSaveDto.new(json["data"])
