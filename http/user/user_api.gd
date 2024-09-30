class_name UserApi


func fetch_game_saves(on_failure: Callable) -> FetchGameSavesDto:
	var response: HTTPResult = await Http.api_client.fetch(ApiRoutes.FETCH_GAME_SAVES, true)

	if !response.success() or response.status_err():
		on_failure.call(response)
		push_error("Request failed.")
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		push_error("JSON invalid.")
		on_failure.call(response)
		return null

	return FetchGameSavesDto.new(json["data"])
