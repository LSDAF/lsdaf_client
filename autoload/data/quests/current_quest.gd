extends Node

signal quest_update

@export var mob_quest_blueprint: MobQuest
@export var stage_quest_blueprint: StageQuest

var _quest: Quest
var _stage_last_milestone := 0

func _ready() -> void:
	_quest = _init_mob_quest()

func get_quest() -> Quest:
	return _quest

func on_mob_death() -> void:
	if not (_quest is MobQuest):
		return
		
	_quest.score += 1	
	quest_update.emit()

func on_progress_stage() -> void:
	if not (_quest is StageQuest):
		return
		
	_quest.score += 1
	quest_update.emit()
	
func is_redeemable() -> bool:
	return _quest.score >= _quest.goal

func redeem() -> void:
	_reward_player()
	
	var new_quest: Quest
	
	if (_quest is MobQuest):
		new_quest = _init_stage_quest()
	elif (_quest is StageQuest):
		new_quest = _init_mob_quest()
		_stage_last_milestone = _quest.goal
	else:
		return
		
	_quest = new_quest
	quest_update.emit()

func _init_mob_quest() -> Quest:
	var quest := mob_quest_blueprint
	
	quest.goal = quest.nb_kills
	quest.score = 0
	
	return quest

func _init_stage_quest() -> Quest:
	var quest := stage_quest_blueprint
	
	quest.goal = _stage_last_milestone + quest.stage_interval
	quest.score = Stage.get_max_stage()
	
	return quest

func _reward_player() -> void:
	Currencies.diamond.update_value(_quest.reward)
