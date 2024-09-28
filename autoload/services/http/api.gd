extends Node

var access_token: String = ""

var auth: AuthApi = preload("res://http/auth/auth_api.gd").new()
var game_save: GameSaveApi = preload("res://http/game_save/game_save_api.gd").new()
var user: UserApi = preload("res://http/user/user_api.gd").new()