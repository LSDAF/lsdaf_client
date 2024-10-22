class_name CurrencyApi


func update_game_save_currencies(
	game_save_id: String,
	gold: int,
	diamonds: int,
	emeralds: int,
	amethysts: int,
	on_failure: Callable
) -> bool:
	var body: Dictionary = {}

	if gold != null:
		body["gold"] = gold

	if diamonds != null:
		body["diamonds"] = diamonds

	if emeralds != null:
		body["emeralds"] = emeralds

	if amethysts != null:
		body["amethysts"] = amethysts

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
