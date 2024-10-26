class_name MobQuest
extends Quest

@export var nb_kills: int

static func create_from_dict(dictionary: Dictionary) -> MobQuest:
	var quest: MobQuest = MobQuest.new()

	quest.name = dictionary["name"]
	quest.reward = dictionary["reward"]
	quest.nb_kills = dictionary["nb_kills"]
	quest.score = dictionary["score"]
	quest.goal = dictionary["goal"]

	return quest
