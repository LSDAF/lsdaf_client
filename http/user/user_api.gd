class_name UserApi

func fetch_game_saves(on_failure: Callable) -> FetchGameSavesDto:
	var response: HTTPResult = await Http.http.async_request(
		ApiRoutes.FETCH_GAME_SAVES,
		['Authorization: Bearer {0}'.format([Api.access_token])],
		HTTPClient.METHOD_GET,
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		return null

	var json: Dictionary = response.body_as_json()

	print(json)

	if not json:
		push_error("JSON invalid.")
		return null

	return FetchGameSavesDto.new(json['data'])
