class_name GameSaveDto

var id: String
var created_at: int
var gold: int


func _init(dictionary: Dictionary) -> void:
	id = dictionary["id"]

	created_at = Time.get_unix_time_from_datetime_string(dictionary["created_at"])
	gold = dictionary["gold"]
