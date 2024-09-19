class_name FetchGameSavesDto

#region GameSave class
class GameSave:
	var id: String
	var created_at: int
	var gold: int

	func _init(dictionary: Dictionary) -> void:
		id = dictionary['id']
		
		created_at = Time.get_unix_time_from_datetime_string(dictionary['created_at'])
		gold = dictionary['gold']
#endregion

var game_saves: Array[GameSave]

func _init(dictionary: Array) -> void:
	for game_save: Dictionary in dictionary:
		game_saves.push_back(GameSave.new(game_save))
