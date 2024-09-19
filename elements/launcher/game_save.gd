extends Control

class_name GameSaveNode

var _game_id: String
var _gold: int
var _created_at: int


func _ready() -> void:
	%GameIdLabel.text = _game_id
	%GameGoldLabel.text = 'Gold: {0}'.format([str(_gold)])
	%GameCreatedAtLabel.text = 'Created: {0}'.format([Time.get_datetime_string_from_unix_time(_created_at)])

func initialize(game_id: String, gold: int, created_at: int) -> void:
	_game_id = game_id
	_gold = gold
	_created_at = created_at
