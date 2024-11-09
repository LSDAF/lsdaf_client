class_name CharacteristicsApi


func update_game_save_characteristics(
	game_save_id: String, update_characteristics_dto: UpdateCharacteristicsDto, on_failure: Callable
) -> bool:
	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.UPDATE_GAME_SAVE_CHARACTERISTICS.format({"game_save_id": game_save_id}),
		true,
		update_characteristics_dto.to_dictionary()
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return false

	return true
