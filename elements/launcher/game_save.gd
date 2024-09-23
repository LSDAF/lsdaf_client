extends Control

class_name GameSave

signal game_loaded

var _game_save_dto: GameSaveDto


func _ready() -> void:
	%GameIdLabel.text = _game_save_dto.id
	%GameGoldLabel.text = 'Gold: {0}'.format([str(_game_save_dto.gold)])
	%GameCreatedAtLabel.text = 'Created: {0}'.format([Time.get_datetime_string_from_unix_time(_game_save_dto.created_at)])

func initialize(game_save_dto: GameSaveDto, on_game_loaded: Callable) -> void:
	_game_save_dto = game_save_dto
	game_loaded.connect(on_game_loaded)


func _on_pressed() -> void:
	print("clicked load game")
	GameSaveService.load_game_save(_game_save_dto)
	game_loaded.emit()
