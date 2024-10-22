extends Node

var auth: AuthApi = preload("res://http/auth/auth_api.gd").new()
var currency: CurrenciesApi = preload("res://http/currencies/currencies_api.gd").new()
var game_save: GameSaveApi = preload("res://http/game_save/game_save_api.gd").new()
var stage: StageApi = preload("res://http/stage/stage_api.gd").new()
var user: UserApi = preload("res://http/user/user_api.gd").new()
