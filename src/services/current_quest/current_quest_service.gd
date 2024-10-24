class_name CurrentQuestService



static func _init_mob_quest() -> void:
	var quest: MobQuest = Data.current_quest.mob_quest_blueprint

	quest.goal = quest.nb_kills
	quest.score = 0

	Data.current_quest._quest = quest


static func _init_stage_quest() -> void:
	var quest: StageQuest = Data.current_quest.stage_quest_blueprint

	quest.goal = Data.current_quest._stage_last_milestone + quest.stage_interval
	quest.score = StageService.get_max_stage()

	Data.current_quest._quest = quest


static func _reward_player() -> void:
	Data.currencies.diamond.update_value(Data.current_quest._quest.reward)


static func get_current_quest() -> Quest:
	return Data.current_quest._quest


static func on_mob_death() -> void:
	if not (Data.current_quest._quest is MobQuest):
		return

	Data.current_quest._quest.score += 1
	EventBus.quest_update.emit()


static func on_progress_stage() -> void:
	if not (Data.current_quest._quest is StageQuest):
		return

	Data.current_quest._quest.score += 1
	EventBus.quest_update.emit()


static func is_redeemable() -> bool:
	return Data.current_quest._quest.score >= Data.current_quest._quest.goal


static func redeem() -> void:
	_reward_player()

	if Data.current_quest._quest is MobQuest:
		_init_stage_quest()
	elif Data.current_quest._quest is StageQuest:
		var quest_goal := Data.current_quest._quest.goal

		_init_mob_quest()
		Data.current_quest._stage_last_milestone = quest_goal
	else:
		return

	EventBus.quest_update.emit()
