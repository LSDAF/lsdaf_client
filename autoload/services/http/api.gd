extends Node

var access_token: String = ''

var auth: Auth = preload("res://http/auth/auth.gd").new()
var user: User = preload("res://http/user/user.gd").new()
