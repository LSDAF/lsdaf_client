class_name CurrentQuestService

var _currencies_store: CurrenciesStore
var _current_quest_data: CurrentQuestData


func _init(
	currencies_store: CurrenciesStore,
	current_quest_data: CurrentQuestData,
) -> void:
	_currencies_store = currencies_store
	_current_quest_data = current_quest_data


func _init_mob_quest() -> void:
	var mob_quest: MobQuest = _current_quest_data.mob_quest_blueprint

	var quest: MobQuest = (
		MobQuest
		. create_from_dict(
			{
				"goal": mob_quest.nb_kills,
				"name": mob_quest.name,
				"nb_kills": mob_quest.nb_kills,
				"reward": mob_quest.reward,
				"score": 0,
			}
		)
	)

	_current_quest_data._quest = quest


func _init_stage_quest() -> void:
	var stage_quest: StageQuest = _current_quest_data.stage_quest_blueprint

	var quest: StageQuest = (
		StageQuest
		. create_from_dict(
			{
				"goal": _current_quest_data._stage_last_milestone + stage_quest.stage_interval,
				"name": stage_quest.name,
				"reward": stage_quest.reward,
				"score": _current_quest_data._stage_last_milestone,
				"stage_interval": stage_quest.stage_interval,
			}
		)
	)

	_current_quest_data._quest = quest


func _reward_player() -> void:
	_currencies_store.diamond += _current_quest_data._quest.reward


func get_current_quest() -> Quest:
	return _current_quest_data._quest


func on_mob_death() -> void:
	if not (_current_quest_data._quest is MobQuest):
		return

	_current_quest_data._quest.score += 1
	EventBus.quest_update.emit()


func on_progress_stage() -> void:
	if not (_current_quest_data._quest is StageQuest):
		return

	_current_quest_data._quest.score += 1
	EventBus.quest_update.emit()


func is_redeemable() -> bool:
	return _current_quest_data._quest.score >= _current_quest_data._quest.goal


func redeem() -> void:
	_reward_player()

	if _current_quest_data._quest is MobQuest:
		_init_stage_quest()
	elif _current_quest_data._quest is StageQuest:
		var quest_goal := _current_quest_data._quest.goal

		_init_mob_quest()
		_current_quest_data._stage_last_milestone = quest_goal
	else:
		return

	EventBus.quest_update.emit()
