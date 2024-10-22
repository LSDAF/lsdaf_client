class_name CurrenciesApi

func fetch_game_save_currencies(game_save_id: String, on_failure: Callable) -> FetchCurrenciesDto:
	var response: HTTPResult = await Http.api_client.fetch(
		Http.api_routes.FETCH_GAME_SAVES_CURRENCIES.format({"game_save_id": game_save_id}), true
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

	return FetchCurrenciesDto.new(json["data"])


func update_game_save_currencies(
	game_save_id: String,
	gold: int,
	diamond: int,
	emerald: int,
	amethyst: int,
	on_failure: Callable
) -> bool:
	var body: Dictionary = {}

	if gold != null:
		body["gold"] = gold

	if diamond != null:
		body["diamond"] = diamond

	if emerald != null:
		body["emerald"] = emerald

	if amethyst != null:
		body["amethyst"] = amethyst

	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.UPDATE_GAME_SAVE_CURRENCIES.format({"game_save_id": game_save_id}),
		true,
		body
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return false

	return true
