class_name CurrentQuestService

signal quest_update

func _init_mob_quest() -> Quest:
	var quest := Data.current_quest.mob_quest_blueprint

	quest.goal = quest.nb_kills
	quest.score = 0

	return quest


func _init_stage_quest() -> Quest:
	var quest := Data.current_quest.stage_quest_blueprint

	quest.goal = Data.current_quest._stage_last_milestone + quest.stage_interval
	quest.score = Data.stage.get_max_stage()

	return quest


func _reward_player() -> void:
	Data.currencies.diamond.update_value(Data.current_quest._quest.reward)


func get_current_quest() -> Quest:
	return Data.current_quest._quest


func on_mob_death() -> void:
	if not (Data.current_quest._quest is MobQuest):
		return

	Data.current_quest._quest.score += 1
	quest_update.emit()


func on_progress_stage() -> void:
	if not (Data.current_quest._quest is StageQuest):
		return

	Data.current_quest._quest.score += 1
	quest_update.emit()


func is_redeemable() -> bool:
	return Data.current_quest._quest.score >= Data.current_quest._quest.goal


func redeem() -> void:
	_reward_player()

	var new_quest: Quest

	if Data.current_quest._quest is MobQuest:
		_init_stage_quest()
	elif Data.current_quest._quest is StageQuest:
		new_quest = _init_mob_quest()
		Data.current_quest._stage_last_milestone = Data.current_quest._quest.goal
	else:
		return

	Data.current_quest._quest = new_quest
	quest_update.emit()
