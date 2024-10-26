extends GutTest

var sut: CurrentQuestService

var currencies_data := preload("res://src/data/currencies/currencies_data.gd")
var current_quest_data := preload("res://src/data/current_quest/current_quest_data.gd")
var stage_service := preload("res://src/services/stage/stage_service.gd")

var currencies_data_partial_double: Variant
var current_quest_data_partial_double: Variant
var stage_service_partial_double: Variant


func before_each() -> void:
	currencies_data_partial_double = partial_double(currencies_data).new()
	current_quest_data_partial_double = partial_double(current_quest_data).new()
	stage_service_partial_double = partial_double(stage_service).new()

	sut = preload("res://src/services/current_quest/current_quest_service.gd").new(
		currencies_data_partial_double,
		current_quest_data_partial_double,
		stage_service_partial_double
	)


func test_init_mob_quest() -> void:
	# Arrange

	# Act
	sut._init_mob_quest()

	# Assert
	assert_eq(current_quest_data_partial_double._quest.goal, 10)
	assert_eq(current_quest_data_partial_double._quest.nb_kills, 10)
	assert_eq(current_quest_data_partial_double._quest.reward, 3000)
	assert_eq(current_quest_data_partial_double._quest.score, 0)


func test_init_stage_quest() -> void:
	# Arrange
	current_quest_data_partial_double._stage_last_milestone = 100
	current_quest_data_partial_double.stage_quest_blueprint.stage_interval = 2

	stub(stage_service_partial_double, "get_max_stage").to_return(5)

	# Act
	sut._init_stage_quest()

	# Assert
	assert_eq(current_quest_data_partial_double._quest.goal, 102)
	assert_eq(current_quest_data_partial_double._quest.reward, 3000)
	assert_eq(current_quest_data_partial_double._quest.score, 5)
	assert_eq(current_quest_data_partial_double._quest.stage_interval, 2)


func test_reward_player() -> void:
	# Arrange
	current_quest_data_partial_double._quest = MobQuest.new()
	current_quest_data_partial_double._quest.reward = 1234

	# Act
	sut._reward_player()

	# Assert
	assert_eq(currencies_data_partial_double.diamond.get_value(), 1234)


func test_get_current_quest() -> void:
	# Arrange
	current_quest_data_partial_double._quest = MobQuest.new()

	# Act
	var current_quest: Quest = sut.get_current_quest()

	# Assert
	assert_eq(current_quest, current_quest_data_partial_double._quest)


# Parameters
# [current_quest, current_score]
var test_on_mob_death_parameters := [
	[MobQuest.new(), 0],
	[MobQuest.new(), 1],
	[MobQuest.new(), 9],
	[StageQuest.new(), 1],
	[StageQuest.new(), 0],
	[StageQuest.new(), 9],
]


func test_on_mob_death(params: Array = use_parameters(test_on_mob_death_parameters)) -> void:
	# Arrange
	current_quest_data_partial_double._quest = params[0]
	current_quest_data_partial_double._quest.score = params[1]

	# Act
	sut.on_mob_death()

	# Assert
	if current_quest_data_partial_double._quest is MobQuest:
		assert_eq(current_quest_data_partial_double._quest.score, params[1] + 1)
	else:
		assert_eq(current_quest_data_partial_double._quest.score, params[1])


# Parameters
# [current_quest, current_score]
var test_on_progress_stage_parameters := [
	[MobQuest.new(), 0],
	[StageQuest.new(), 0],
	[MobQuest.new(), 1],
	[StageQuest.new(), 1],
	[MobQuest.new(), 9],
	[StageQuest.new(), 9],
]


func test_on_progress_stage(
	params: Array = use_parameters(test_on_progress_stage_parameters)
) -> void:
	# Arrange
	current_quest_data_partial_double._quest = params[0]
	current_quest_data_partial_double._quest.score = params[1]

	# Act
	sut.on_progress_stage()

	# Assert
	if current_quest_data_partial_double._quest is StageQuest:
		assert_eq(current_quest_data_partial_double._quest.score, params[1] + 1)
	else:
		assert_eq(current_quest_data_partial_double._quest.score, params[1])


# Parameters
# [quest_score, quest_goal]
var test_is_redeemable_parameters := [
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
]


func test_is_redeemable(params: Array = use_parameters(test_is_redeemable_parameters)) -> void:
	# Arrange
	current_quest_data_partial_double._quest = MobQuest.new()
	current_quest_data_partial_double._quest.goal = params[1]
	current_quest_data_partial_double._quest.score = params[0]

	# Act
	var is_redeemable: bool = sut.is_redeemable()

	# Assert
	assert_eq(is_redeemable, params[0] >= params[1])


# Parameters
# [current_quest, current_stage_last_milestone, current_goal]
var test_redeem_parameters := [
	[MobQuest.new(), 0, 0],
	[MobQuest.new(), 0, 1],
	[StageQuest.new(), 0, 0],
	[StageQuest.new(), 0, 1],
	[StageQuest.new(), 0, 10],
	[StageQuest.new(), 0, 100],
	[MobQuest.new(), 50, 0],
	[MobQuest.new(), 50, 1],
	[StageQuest.new(), 50, 0],
	[StageQuest.new(), 50, 1],
	[StageQuest.new(), 50, 10],
	[StageQuest.new(), 50, 100],
]


func test_redeem(params: Array = use_parameters(test_redeem_parameters)) -> void:
	# Arrange
	current_quest_data_partial_double._quest = params[0]
	current_quest_data_partial_double._stage_last_milestone = params[1]
	current_quest_data_partial_double._quest.goal = params[2]

	stub(stage_service_partial_double, "get_max_stage").to_return(50)

	var current_quest_before_redeem_is_mob_quest: bool = (
		current_quest_data_partial_double._quest is MobQuest
	)

	# Act
	sut.redeem()

	# Assert
	if current_quest_before_redeem_is_mob_quest:
		assert_eq(current_quest_data_partial_double._quest is StageQuest, true)
		assert_eq(current_quest_data_partial_double._stage_last_milestone, params[1])
	else:
		assert_eq(current_quest_data_partial_double._quest is MobQuest, true)
		assert_eq(current_quest_data_partial_double._stage_last_milestone, params[2])
