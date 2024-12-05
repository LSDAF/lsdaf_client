class_name InventoryApi


func fetch_game_save_inventory(game_save_id: String, on_failure: Callable) -> FetchInventoryDto:
	var response: HTTPResult = await Http.api_client.fetch(
		Http.api_routes.FETCH_GAME_SAVES_INVENTORY.format({"game_save_id": game_save_id}), true
	)

	if !response.success() or response.status_err():
		on_failure.call(response)
		push_error("Request failed.")
		return null

	var json: Dictionary = response.body_as_json()

	if not json:
		on_failure.call(response)
		push_error("JSON invalid.")
		return null

	return FetchInventoryDto.new(json["data"])
