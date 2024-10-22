extends Node

class_name ApiRoutes

var APP_PORT: int = 8080
var APP_URL: String = "http://localhost:" + str(APP_PORT)

# Public routes
var LOGIN := APP_URL + "/api/v1/auth/login"
var REFRESH_LOGIN := APP_URL + "/api/v1/auth/refresh_login"
var REGISTER := APP_URL + "/api/v1/auth/register"

# Private routes
var FETCH_GAME_SAVES := APP_URL + "/api/v1/user/me/game_saves"
var FETCH_GAME_SAVES_STAGE := APP_URL + "/api/v1/stage/{game_save_id}"
var FETCH_GAME_SAVES_CURRENCIES := APP_URL + "/api/v1/currency/{game_save_id}"
var GENERATE_GAME_SAVE := APP_URL + "/api/v1/game_save/generate"
var UPDATE_GAME_SAVE_CURRENCIES := APP_URL + "/api/v1/currency/{game_save_id}"
var UPDATE_GAME_SAVE_STAGE := APP_URL + "/api/v1/stage/{game_save_id}"
var UPDATE_GAME_SAVE_NICKNAME := APP_URL + "/api/v1/game_save/{game_save_id}/nickname"
