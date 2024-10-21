extends Node

class_name GameSaveService

var _game_save_id: String = ""
var _last_save_time: float = 0


func get_game_save_id() -> String:
	return _game_save_id


func load_game_save(game_save_dto: GameSaveDto) -> void:
	_game_save_id = game_save_dto.id


func save_game() -> void:
	var success := await _save_currencies()  # and save_nickname() and ...

	if success:
		_last_save_time = Time.get_unix_time_from_system()
		Services.toaster.toast("Game saved.")
	else:
		Services.toaster.toast("Failed to save game.")


func _save_currencies() -> bool:
	return await Api.game_save.update_game_save_currencies(
		_game_save_id,
		Data.currencies.gold.get_value(),
		Data.currencies.diamond.get_value(),
		Data.currencies.emerald.get_value(),
		Data.currencies.amethyst.get_value(),
		_on_save_currencies_error
	)


func _on_save_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save currencies.")
