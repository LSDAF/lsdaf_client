# GdUnit generated TestSuite
class_name CurrentQuestServiceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://src/autoload/services/current_quest/current_quest_service.gd'


func before_test() -> void:
	Data.current_quest.mob_quest_blueprint = load("res://src/resources/quests/mob_quest.tres")
	Data.current_quest.stage_quest_blueprint = load("res://src/resources/quests/stage_quest.tres")
	Data.current_quest._quest = null
	Data.current_quest._stage_last_milestone = 0
	Data.currencies.amethyst._value = 0
	Data.currencies.diamond._value = 0
	Data.currencies.emerald._value = 0
	Data.currencies.gold._value = 0

func test__init_mob_quest() -> void:
	# Arrange

	# Act
	CurrentQuestService._init_mob_quest()
	var quest: MobQuest = Data.current_quest._quest

	# Assert
	assert_int(quest.score).is_equal(0)
	assert_int(quest.goal).is_equal(10)
	assert_int(quest.nb_kills).is_equal(10)

func test__init_stage_quest() -> void:
	# Arrange

	# Act
	CurrentQuestService._init_stage_quest()
	var quest: StageQuest = Data.current_quest._quest

	# Assert
	assert_int(quest.score).is_equal(1)
	assert_int(quest.goal).is_equal(Data.current_quest._stage_last_milestone + quest.stage_interval)

	assert_int(quest.stage_interval).is_equal(2)


func test__reward_player() -> void:
	# Arrange
	Data.currencies.diamond._value = 10

	CurrentQuestService._init_stage_quest()
	var quest: StageQuest = Data.current_quest._quest

	# Act
	CurrentQuestService._reward_player()

	# Assert
	assert_int(Data.currencies.diamond.get_value()).is_equal(10 + quest.reward)


func test__get_current_quest() -> void:
	# Arrange
	CurrentQuestService._init_mob_quest()
	var quest: MobQuest = Data.current_quest._quest

	# Act
	var current_quest: Quest = CurrentQuestService.get_current_quest()

	# Assert
	assert_that(current_quest).is_equal(quest)


func test__on_mob_death(current_quest: Quest, current_score: int, test_parameters := [
		[MobQuest.new(), 0],
		[MobQuest.new(), 1],
		[MobQuest.new(), 9],
		[StageQuest.new(), 1],
		[StageQuest.new(), 0],
		[StageQuest.new(), 9],
]) -> void:
	# Arrange
	Data.current_quest._quest = current_quest
	Data.current_quest._quest.score = current_score

	# Act
	CurrentQuestService.on_mob_death()

	# Assert
	if current_quest is MobQuest:
		assert_int(Data.current_quest._quest.score).is_equal(current_score + 1)
	else:
		assert_int(Data.current_quest._quest.score).is_equal(current_score)


func test__on_progress_stage(current_quest: Quest, current_score: int, test_parameters := [
		[MobQuest.new(), 0],
		[StageQuest.new(), 0],
		[MobQuest.new(), 1],
		[StageQuest.new(), 1],
		[MobQuest.new(), 9],
		[StageQuest.new(), 9],
]) -> void:
	# Arrange
	Data.current_quest._quest = current_quest
	Data.current_quest._quest.score = current_score

	# Act
	CurrentQuestService.on_progress_stage()

	# Assert
	if current_quest is StageQuest:
		assert_int(Data.current_quest._quest.score).is_equal(current_score + 1)
	else:
		assert_int(Data.current_quest._quest.score).is_equal(current_score)


func test__is_redeemable(quest_score: int, quest_goal: int, test_parameters := [
		[0, 1],
		[1, 1],
		[1, 2],
		[1, 5],
		[4, 5],
		[5, 5],
		[6, 5],
 		[25, 5],
		[1, 10],
		[9, 10],
		[10, 10],
		[11, 10],
		[100, 10],
]) -> void:
	# Arrange
	CurrentQuestService._init_mob_quest()
	var quest: MobQuest = Data.current_quest._quest

	# Act
	var is_redeemable: bool = CurrentQuestService.is_redeemable()

	# Assert
	assert_bool(is_redeemable).is_equal(quest.score >= quest.goal)


func test__redeem(current_quest: Quest, current_stage_last_milestone: int, current_goal: int, test_parameters := [
		[MobQuest.new(), 0, 0],
		[MobQuest.new(), 0, 1],
		[StageQuest.new(), 0, 0],
		[StageQuest.new(), 0, 1],
		[StageQuest.new(), 0, 10],
		[StageQuest.new(), 0, 100],
]) -> void:
	# Arrange
	current_quest.goal = current_goal
	Data.current_quest._quest = current_quest

	Data.current_quest._stage_last_milestone = current_stage_last_milestone

	# Act
	CurrentQuestService.redeem()

	# Assert
	if current_quest is MobQuest:
		assert_bool(Data.current_quest._quest is StageQuest).is_true()
		assert_int(Data.current_quest._stage_last_milestone).is_equal(current_stage_last_milestone)
	else:
		assert_bool(Data.current_quest._quest is MobQuest).is_true()
		assert_int(Data.current_quest._stage_last_milestone).is_equal(current_goal)
