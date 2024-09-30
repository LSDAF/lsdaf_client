class_name GameSaveApi


func generate_game_save(on_failure: Callable) -> GameSaveDto:
	var response: HTTPResult = await (
		Http
		. http
		. async_request(
			ApiRoutes.GENERATE_GAME_SAVE,
			["Authorization: Bearer {0}".format([UserDataService.get_access_token()])],
			HTTPClient.METHOD_POST,
		)
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

	return GameSaveDto.new(json["data"])


func update_game_save_nickname(
	game_save_id: String, nickname: String, on_failure: Callable
) -> bool:
	var body: String = (
		JSON
		. stringify(
			{
				"nickname": nickname,
			}
		)
	)

	var response: HTTPResult = await (Http.http.async_request(
		ApiRoutes.UPDATE_GAME_SAVE_NICKNAME.format({"game_save_id": game_save_id}),
		[
			"Authorization: Bearer {0}".format([UserDataService.get_access_token()]),
			"Content-Type: application/json"
		],
		HTTPClient.METHOD_POST,
		body
	))

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return false

	return true
