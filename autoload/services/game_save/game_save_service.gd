extends Node

class_name GameSaveService

var _game_save_id: String = ""
var _last_save_time: float = 0


func get_game_save_id() -> String:
	return _game_save_id


func load_game_save(game_save_dto: GameSaveDto) -> void:
	_game_save_id = game_save_dto.id

	var fetched_currencies := await Api.currency.fetch_game_save_currencies(_game_save_id, _on_fetch_currencies_error)
	Data.currencies._set_currencies(
		fetched_currencies.gold,
		fetched_currencies.diamond,
		fetched_currencies.emerald,
		fetched_currencies.amethyst
	)

	var fetched_stage := await Api.stage.fetch_game_save_stage(_game_save_id, _on_fetch_stage_error)
	Data.stage.set_current_stage(fetched_stage.current_stage)
	Data.stage.set_max_stage(fetched_stage.max_stage)

func save_game() -> void:
	var success := await _save_currencies() and await _save_stage()

	if success:
		_last_save_time = Time.get_unix_time_from_system()
		Services.toaster.toast("Game saved.")
	else:
		Services.toaster.toast("Failed to save game.")


func _save_currencies() -> bool:
	var update_currencies_dto := UpdateCurrenciesDto.new({
		"gold": Data.currencies.gold.get_value(),
		"diamond": Data.currencies.diamond.get_value(),
		"emerald": Data.currencies.emerald.get_value(),
		"amethyst": Data.currencies.amethyst.get_value(),
	})

	return await Api.currency.update_game_save_currencies(
		_game_save_id,
		update_currencies_dto,
		_on_save_currencies_error
	)

func _save_stage() -> bool:
	var update_stage_dto := UpdateStageDto.new({
		"current_stage": Data.stage.get_current_stage(),
		"max_stage": Data.stage.get_max_stage(),
	})

	return await Api.stage.update_game_save_stage(
		_game_save_id,
		update_stage_dto,
		_on_save_stage_error
	)


func _on_fetch_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch currencies.")


func _on_fetch_stage_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch stage.")


func _on_save_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save currencies.")

func _on_save_stage_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save stage.")
