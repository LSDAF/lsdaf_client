extends GutTest

var sut: UserLocalDataService

var auth_api := preload("res://src/http/auth/auth_api.gd")
var user_local_data := preload("res://src/data/user_local/user_local_data.gd")
var resource_loader := preload("res://src/services/resource_loader/resource_loader_service.gd")
var resource_saver := preload("res://src/services/resource_saver/resource_saver_service.gd")

var auth_api_partial_double: AuthApi
var user_local_data_partial_double: UserLocalData
var resource_loader_partial_double: ResourceLoaderService
var resource_saver_partial_double: ResourceSaverService


func before_each() -> void:
	auth_api_partial_double = partial_double(auth_api).new()
	user_local_data_partial_double = partial_double(user_local_data).new()
	resource_loader_partial_double = partial_double(resource_loader).new()
	resource_saver_partial_double = partial_double(resource_saver).new()

	sut = preload("res://src/services/user_local_data/user_local_data_service.gd").new(
		auth_api_partial_double,
		user_local_data_partial_double,
		resource_loader_partial_double,
		resource_saver_partial_double
	)


# Parameters
# [remember_me, email]
var test_create_new_user_data_parameters := [
	[true, "test@test.com"],
	[true, ""],
	[false, "test@test.com"],
	[false, ""],
]


func test_create_new_user_data(
	params: Array = use_parameters(test_create_new_user_data_parameters)
) -> void:
	# Arrange
	var remember_me: bool = params[0]
	var email: String = params[1]

	user_local_data_partial_double._user_data = null

	if params[0] or params[1]:
		user_local_data_partial_double._user_data = UserData.new()
		user_local_data_partial_double._user_data.remember_me = remember_me
		user_local_data_partial_double._user_data.email = email

	# Act
	sut.create_new_user_data()

	# Assert
	assert_true(user_local_data_partial_double._user_data is UserData)

	if remember_me and email:
		assert_eq(user_local_data_partial_double._user_data.remember_me, true)
		assert_eq(user_local_data_partial_double._user_data.email, email)


# Parameters
# [user_data_exists, local_user_data]
var test_load_parameters := [
	[true, UserData.new()],
	[true, Resource.new()],
	[false, null],
]


func test_load(params: Array = use_parameters(test_load_parameters)) -> void:
	# Arrange
	var user_data_exists: bool = params[0]
	var local_user_data: Resource = params[1]

	stub(resource_loader_partial_double, "exists").to_return(user_data_exists)
	stub(resource_loader_partial_double, "load").to_return(local_user_data)

	# Act
	var user_data: UserData = sut.load()

	# Assert
	assert_not_null(user_data)
	assert_true(user_data is UserData)

	if user_data_exists and local_user_data is UserData:
		assert_eq(user_data, local_user_data)
	else:
		assert_ne(user_data, local_user_data)


# Parameters
# [user_data_refresh_token, user_data_email, refresh_login_response, expected_result]
var test_relog_user_parameters := [
	["", "", null, false],
	[
		"valid_refresh_token",
		"valid_email",
		(
			LoginResponseDto
			. new(
				{
					"access_token": "test_access_token",
					"refresh_token": "test_refresh_token",
					"user_info":
					{
						"id": "valid_id",
						"name": "valid_name",
						"email": "valid_email",
					}
				}
			)
		),
		true
	],
	["invalid_refresh_token", "invalid_email", null, false],
	["valid_refresh_token", "", null, false],
	["", "valid_email", null, false],
]


func test_relog_user(params: Array = use_parameters(test_relog_user_parameters)) -> void:
	# Arrange
	var user_data_refresh_token: String = params[0]
	var user_data_email: String = params[1]
	var refresh_login_response: LoginResponseDto = params[2]
	var expected_result: bool = params[3]

	user_local_data_partial_double._user_data = UserData.new()
	user_local_data_partial_double._user_data.refresh_token = user_data_refresh_token
	user_local_data_partial_double._user_data.email = user_data_email

	(
		stub(auth_api_partial_double, "refresh_login")
		. when_passed(user_data_email, user_data_refresh_token, sut._on_relog_failed)
		. to_return(refresh_login_response)
	)

	# Act
	var relog_user: bool = await sut.relog_user()

	# Assert
	assert_eq(relog_user, expected_result)


# Parameters
# [resource_saver_save_result]
var test_save_to_device_parameters := [
	[OK],
	[ERR_FILE_CANT_OPEN],
	[ERR_FILE_CORRUPT],
	[ERR_FILE_BAD_DRIVE],
	[ERR_FILE_BAD_PATH],
]


func test_save_to_device(params: Array = use_parameters(test_save_to_device_parameters)) -> void:
	# Arrange
	var resource_saver_save_result: int = params[0]

	stub(resource_saver_partial_double, "save").to_return(resource_saver_save_result)

	# Act
	var save_to_device: Error = await sut.save_to_device()

	# Assert
	assert_eq(save_to_device, resource_saver_save_result)


# Parameters
# [local_user_data, local_access_token, expected_result]
var test_get_access_token_parameters := [
	[UserData.new(), "test_access_token", "test_access_token"],
	[UserData.new(), "", ""],
	[null, "test_access_token", ""],
	[null, "", ""],
]


func test_get_access_token(
	params: Array = use_parameters(test_get_access_token_parameters)
) -> void:
	# Arrange
	var local_user_data: UserData = params[0]
	var local_access_token: Variant = params[1]
	var expected_result: String = params[2]

	user_local_data_partial_double._user_data = local_user_data
	if local_user_data:
		user_local_data_partial_double._user_data.access_token = local_access_token

	# Act
	var access_token: String = sut.get_access_token()

	# Assert
	assert_eq(access_token, expected_result)


func test_get_email() -> void:
	# Arrange
	user_local_data_partial_double._user_data = UserData.new()
	user_local_data_partial_double._user_data.email = "test_email"

	# Act
	var email: String = sut.get_email()

	# Assert
	assert_eq(email, "test_email")


func test_get_refresh_token() -> void:
	# Arrange
	user_local_data_partial_double._user_data = UserData.new()
	user_local_data_partial_double._user_data.refresh_token = "test_refresh_token"

	# Act
	var refresh_token: String = sut.get_refresh_token()

	# Assert
	assert_eq(refresh_token, "test_refresh_token")


func test_get_remember_me() -> void:
	# Arrange
	user_local_data_partial_double._user_data = UserData.new()
	user_local_data_partial_double._user_data.remember_me = true

	# Act
	var remember_me: bool = sut.get_remember_me()

	# Assert
	assert_eq(remember_me, true)


# Parameters
# [save_to_device_result, expected_result]
var test_save_access_token_parameters := [
	[OK, true],
	[ERR_FILE_CANT_OPEN, false],
	[ERR_FILE_CORRUPT, false],
	[ERR_FILE_BAD_DRIVE, false],
	[ERR_FILE_BAD_PATH, false],
]


func test_save_access_token(
	params: Array = use_parameters(test_save_access_token_parameters)
) -> void:
	# Arrange
	var save_to_device_result: int = params[0]
	var expected_result: bool = params[1]

	user_local_data_partial_double._user_data = UserData.new()

	stub(resource_saver_partial_double, "save").to_return(save_to_device_result)

	# Act
	var save_access_token: bool = sut.save_access_token("test_access_token")

	# Assert
	assert_eq(save_access_token, expected_result)


# Parameters
# [save_to_device_result, expected_result]
var test_save_refresh_token_parameters := [
	[OK, true],
	[ERR_FILE_CANT_OPEN, false],
	[ERR_FILE_CORRUPT, false],
	[ERR_FILE_BAD_DRIVE, false],
	[ERR_FILE_BAD_PATH, false],
]


func test_save_refresh_token(
	params: Array = use_parameters(test_save_refresh_token_parameters)
) -> void:
	# Arrange
	var save_to_device_result: int = params[0]
	var expected_result: bool = params[1]

	user_local_data_partial_double._user_data = UserData.new()

	stub(resource_saver_partial_double, "save").to_return(save_to_device_result)

	# Act
	var save_refresh_token: bool = sut.save_refresh_token("test_refresh_token")

	# Assert
	assert_eq(save_refresh_token, expected_result)


# Parameters
# [save_to_device_result, expected_result]
var test_save_remember_me_parameters := [
	[OK, true],
	[ERR_FILE_CANT_OPEN, false],
	[ERR_FILE_CORRUPT, false],
	[ERR_FILE_BAD_DRIVE, false],
	[ERR_FILE_BAD_PATH, false],
]


func test_save_remember_me(
	params: Array = use_parameters(test_save_remember_me_parameters)
) -> void:
	# Arrange
	var save_to_device_result: int = params[0]
	var expected_result: bool = params[1]

	user_local_data_partial_double._user_data = UserData.new()

	stub(resource_saver_partial_double, "save").to_return(save_to_device_result)

	# Act
	var save_remember_me: bool = sut.save_remember_me(true)

	# Assert
	assert_eq(save_remember_me, expected_result)


# Parameters
# [save_to_device_result, expected_result]
var test_save_email_parameters := [
	[OK, true],
	[ERR_FILE_CANT_OPEN, false],
	[ERR_FILE_CORRUPT, false],
	[ERR_FILE_BAD_DRIVE, false],
	[ERR_FILE_BAD_PATH, false],
]


func test_save_email(params: Array = use_parameters(test_save_email_parameters)) -> void:
	# Arrange
	var save_to_device_result: int = params[0]
	var expected_result: bool = params[1]

	user_local_data_partial_double._user_data = UserData.new()

	stub(resource_saver_partial_double, "save").to_return(save_to_device_result)

	# Act
	var save_email: bool = sut.save_email("test_email")

	# Assert
	assert_eq(save_email, expected_result)
