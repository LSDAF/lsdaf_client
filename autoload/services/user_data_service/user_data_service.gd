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


func relog_user() -> bool:
	if _user_data.refresh_token == "" or _user_data.email == "":
		return false

	var refreshLoginResponse := await Api.auth.refresh_login(
		_user_data.email, _user_data.refresh_token, _on_relog_failed
	)

	if refreshLoginResponse == null:
		return false

	UserDataService.save_access_token(refreshLoginResponse.access_token)
	UserDataService.save_refresh_token(refreshLoginResponse.refresh_token)
	UserDataService.save_email(refreshLoginResponse.user_info.email)

	return true


func save_to_device() -> Error:
	return ResourceSaver.save(_user_data, USER_DATA_PATH)


func get_access_token() -> String:
	return _user_data.access_token


func get_refresh_token() -> String:
	return _user_data.refresh_token


func save_access_token(access_token: String) -> bool:
	_user_data.access_token = access_token

	var result: Error = save_to_device()
	return result == Error.OK


func save_refresh_token(refresh_token: String) -> bool:
	_user_data.refresh_token = refresh_token

	var result: Error = save_to_device()
	return result == Error.OK


func save_email(email: String) -> bool:
	_user_data.email = email

	var result: Error = save_to_device()
	return result == Error.OK


func _on_relog_failed(response: Variant) -> void:
	ToasterService.toast("Error when relogging")
