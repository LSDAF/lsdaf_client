extends Node

var auth: AuthApi = preload("res://src/http/auth/auth_api.gd").new()
var currency: CurrenciesApi = preload("res://src/http/currencies/currencies_api.gd").new()
var game_save: GameSaveApi = preload("res://src/http/game_save/game_save_api.gd").new()
var stage: StageApi = preload("res://src/http/stage/stage_api.gd").new()
var user: UserApi = preload("res://src/http/user/user_api.gd").new()
