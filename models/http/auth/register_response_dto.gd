class_name RegisterResponseDto

var id: String
var name: String
var email: String


func _init(dictionary: Dictionary) -> void:
	# This is a ternary operation
	name = dictionary["name"] if dictionary["name"] else ""
	email = dictionary["email"]
