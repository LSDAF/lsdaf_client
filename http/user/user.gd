class_name User

func fetch_game_saves(on_failure: Callable) -> void:
	var response: HTTPResult = await Http.http.async_request(
		ApiRoutes.FETCH_GAME_SAVES,
		['Authorization: Bearer {0}'.format([Api.access_token])],
		HTTPClient.METHOD_GET,
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		return

	print("Status code: ", response.status)
	print("Content-Type:", response.headers["content-type"])

	var json: Dictionary = response.body_as_json()

	print(json)

	if not json or not json['data']:
		push_error("JSON invalid.")
		return