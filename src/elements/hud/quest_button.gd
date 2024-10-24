extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.quest_update.connect(on_quest_update)
	disabled = true

	on_quest_update()


func on_quest_update() -> void:
	var quest := CurrentQuestService.get_current_quest()
	text = (
		quest.name
		+ "\n"
		+ "("
		+ str(quest.score)
		+ "/"
		+ str(quest.goal)
		+ ")"
		+ "\n"
		+ str(quest.reward)
	)

	if CurrentQuestService.is_redeemable():
		disabled = false


func _on_pressed() -> void:
	disabled = true
	CurrentQuestService.redeem()
