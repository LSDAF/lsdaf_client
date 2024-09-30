extends Node

var _game_save_id: String = ""


func get_game_save_id() -> String:
	return _game_save_id


func load_game_save(game_save_dto: GameSaveDto) -> void:
	Currencies.gold.update_value(game_save_dto.gold)
	_game_save_id = game_save_dto.id
