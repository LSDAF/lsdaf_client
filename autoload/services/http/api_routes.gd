extends Node

var APP_PORT: int = 8080
var APP_URL: String = "http://localhost:" + str(APP_PORT)

# Public routes
var LOGIN := APP_URL + "/api/v1/auth/login"

# Private routes
var FETCH_GAME_SAVES := APP_URL + "/api/v1/user/me/game_saves"
var GENERATE_GAME_SAVE := APP_URL + "/api/v1/game_save/generate"
