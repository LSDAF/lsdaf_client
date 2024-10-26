class_name StageQuest
extends Quest

@export var stage_interval: int

static func create_from_dict(dictionary: Dictionary) -> StageQuest:
	var quest: StageQuest = StageQuest.new()

	quest.name = dictionary["name"]
	quest.reward = dictionary["reward"]
	quest.stage_interval = dictionary["stage_interval"]
	quest.score = dictionary["score"]
	quest.goal = dictionary["goal"]

	return quest