extends Node

class_name CurrentQuest

@export var mob_quest_blueprint: MobQuest
@export var stage_quest_blueprint: StageQuest

var _quest: Quest
var _stage_last_milestone := 0


func _ready() -> void:
	_quest = Services.current_quest._init_mob_quest()
