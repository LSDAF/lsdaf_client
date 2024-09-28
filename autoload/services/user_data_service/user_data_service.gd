extends Node

var _user_data: UserData = null

const USER_DATA_PATH = "user://user_data.res"


func create_new_user_data() -> void:
	_user_data = UserData.new()
	save_to_device()


func load() -> UserData:
	if ResourceLoader.exists(USER_DATA_PATH):
		var user_data := ResourceLoader.load(USER_DATA_PATH)
		if user_data is UserData:  # Check that the data is valid
			_user_data = user_data
			return _user_data

	# If error on loading of the data, generate a new one
	create_new_user_data()

	return _user_data


func save_to_device() -> Error:
	return ResourceSaver.save(_user_data, USER_DATA_PATH)


func get_access_token() -> String:
	return _user_data.access_token


func save_access_token(access_token: String) -> bool:
	_user_data.access_token = access_token

	var result: Error = save_to_device()
	return result == Error.OK
