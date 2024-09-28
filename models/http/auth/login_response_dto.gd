class_name LoginResponseDto

var access_token: String
var user_info: RegisterResponseDto


func _init(dictionary: Dictionary) -> void:
	access_token = dictionary["access_token"]
	user_info = RegisterResponseDto.new(dictionary["user_info"])
