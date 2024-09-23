extends Node


func load_game_save(game_save_dto: GameSaveDto) -> void:
	Currencies.gold.update_value(game_save_dto.gold)
