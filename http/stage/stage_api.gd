class_name StageApi

func update_game_save_stage(game_save_id: String, update_stage_dto: UpdateStageDto, on_failure: Callable) -> bool:
	var response: HTTPResult = await Http.api_client.post(
		Http.api_routes.UPDATE_GAME_SAVE_STAGE.format({"game_save_id": game_save_id}),
		true,
		update_stage_dto.to_dictionary()
	)

	if !response.success() or response.status_err():
		push_error("Request failed.")
		on_failure.call(response)
		return false

	return true