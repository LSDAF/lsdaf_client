class_name CurrentQuestData
extends Node

var mob_quest_blueprint: MobQuest = preload("res://src/resources/quests/mob_quest.tres")
var stage_quest_blueprint: StageQuest = preload("res://src/resources/quests/stage_quest.tres")

var _quest: Quest
var _stage_last_milestone := 0


func _ready() -> void:
	Services.current_quest._init_mob_quest()
