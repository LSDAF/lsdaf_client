class_name LoginResponseDto

class UserInfo:
	var id: String
	var name: String
	var email: String

	func _init(dictionary: Dictionary) -> void:
		id = dictionary['id']
		# This is a ternary operation
		name = dictionary['name'] if dictionary['name'] else ''
		email = dictionary['email']

var access_token: String
var user_info: UserInfo

func _init(dictionary: Dictionary) -> void:
	access_token = dictionary['access_token']
	user_info = UserInfo.new(dictionary['user_info'])
