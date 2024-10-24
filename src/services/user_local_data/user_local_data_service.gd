class_name UserLocalDataService

const USER_DATA_PATH = "user://user_data.res"


static func create_new_user_data() -> void:
	var new_user_data := UserData.new()

	# If user wishes to remember his email
	if Data.user_local_data._user_data.remember_me and Data.user_local_data._user_data.email:
		new_user_data.remember_me = true
		new_user_data.email = Data.user_local_data._user_data.email

	Data.user_local_data._user_data = new_user_data
	save_to_device()


static func load() -> UserData:
	if ResourceLoader.exists(USER_DATA_PATH):
		var user_data := ResourceLoader.load(USER_DATA_PATH)
		if user_data is UserData:  # Check that the data is valid
			Data.user_local_data._user_data = user_data
			return Data.user_local_data._user_data

	# If error on loading of the data, generate a new one
	create_new_user_data()

	return Data.user_local_data._user_data


static func relog_user() -> bool:
	if (
		Data.user_local_data._user_data.refresh_token == ""
		or Data.user_local_data._user_data.email == ""
	):
		return false

	var refreshLoginResponse := await AuthApi.refresh_login(
		Data.user_local_data._user_data.email,
		Data.user_local_data._user_data.refresh_token,
		_on_relog_failed
	)

	if refreshLoginResponse == null:
		return false

	save_access_token(refreshLoginResponse.access_token)
	save_refresh_token(refreshLoginResponse.refresh_token)

	return true


static func save_to_device() -> Error:
	return ResourceSaver.save(Data.user_local_data._user_data, USER_DATA_PATH)


static func get_access_token() -> String:
	return Data.user_local_data._user_data.access_token


static func get_email() -> String:
	return Data.user_local_data._user_data.email


static func get_refresh_token() -> String:
	return Data.user_local_data._user_data.refresh_token


static func get_remember_me() -> bool:
	return Data.user_local_data._user_data.remember_me


static func save_access_token(access_token: String) -> bool:
	Data.user_local_data._user_data.access_token = access_token

	var result: Error = save_to_device()
	return result == Error.OK


static func save_refresh_token(refresh_token: String) -> bool:
	Data.user_local_data._user_data.refresh_token = refresh_token

	var result: Error = save_to_device()
	return result == Error.OK


static func save_remember_me(remember_me: bool) -> bool:
	Data.user_local_data._user_data.remember_me = remember_me

	var result: Error = save_to_device()
	return result == Error.OK


static func save_email(email: String) -> bool:
	Data.user_local_data._user_data.email = email

	var result: Error = save_to_device()
	return result == Error.OK


static func _on_relog_failed(response: Variant) -> void:
	ToasterService.toast("Error when relogging")
