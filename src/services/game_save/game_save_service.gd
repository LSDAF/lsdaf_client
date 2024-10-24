class_name GameSaveService


static func get_game_save_id() -> String:
	return Data.game_save._game_save_id


static func load_game_save(game_save_id: String) -> void:
	Data.game_save._game_save_id = game_save_id

	var fetched_currencies := await CurrenciesApi.fetch_game_save_currencies(
		Data.game_save._game_save_id, _on_fetch_currencies_error
	)
	CurrenciesService._set_currencies(
		fetched_currencies.gold,
		fetched_currencies.diamond,
		fetched_currencies.emerald,
		fetched_currencies.amethyst
	)

	var fetched_stage := await StageApi.fetch_game_save_stage(
		Data.game_save._game_save_id, _on_fetch_stage_error
	)
	StageService.set_current_stage(fetched_stage.current_stage)
	StageService.set_max_stage(fetched_stage.max_stage)


static func save_game() -> void:
	var success := await _save_currencies() and await _save_stage()

	if success:
		Data.game_save._last_save_time = Time.get_unix_time_from_system()
		ToasterService.toast("Game saved.")
	else:
		ToasterService.toast("Failed to save game.")


static func _save_currencies() -> bool:
	var update_currencies_dto := (
		UpdateCurrenciesDto
		. new(
			{
				"gold": Data.currencies.gold.get_value(),
				"diamond": Data.currencies.diamond.get_value(),
				"emerald": Data.currencies.emerald.get_value(),
				"amethyst": Data.currencies.amethyst.get_value(),
			}
		)
	)

	return await CurrenciesApi.update_game_save_currencies(
		Data.game_save._game_save_id, update_currencies_dto, _on_save_currencies_error
	)


static func _save_stage() -> bool:
	var update_stage_dto := (
		UpdateStageDto
		. new(
			{
				"current_stage": StageService.get_current_stage(),
				"max_stage": StageService.get_max_stage(),
			}
		)
	)

	return await StageApi.update_game_save_stage(
		Data.game_save._game_save_id, update_stage_dto, _on_save_stage_error
	)


static func _on_fetch_currencies_error(response: Variant) -> void:
	ToasterService.toast("Failed to fetch currencies.")


static func _on_fetch_stage_error(response: Variant) -> void:
	ToasterService.toast("Failed to fetch stage.")


static func _on_save_currencies_error(response: Variant) -> void:
	ToasterService.toast("Failed to save currencies.")


static func _on_save_stage_error(response: Variant) -> void:
	ToasterService.toast("Failed to save stage.")
