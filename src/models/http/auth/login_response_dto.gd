class_name LoginResponseDto

var access_token: String
var refresh_token: String


func _init(dictionary: Dictionary) -> void:
	access_token = dictionary["access_token"]
	refresh_token = dictionary["refresh_token"]
