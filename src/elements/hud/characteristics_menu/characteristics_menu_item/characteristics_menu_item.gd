extends HBoxContainer

@export var characteristic: Characteristic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characteristic.upgraded.connect(_on_upgraded)
	Services.currencies.connect_gold_updated(_on_gold_value_updated)

	%ValueLabel.text = str(characteristic.current_value()) + " " + characteristic.name
	%LevelLabel.text = "Level " + str(characteristic.get_level())
	%UpgradeButton.set_disabled(
		Services.currencies.get_gold_value() < characteristic.next_level_cost()
	)
	%CostLabel.text = str(characteristic.next_level_cost())


func _on_upgrade_button_button_down() -> void:
	Services.currencies.update_gold_value(-characteristic.next_level_cost())
	characteristic.upgrade()


func _on_upgraded() -> void:
	%ValueLabel.text = str(characteristic.current_value()) + " " + characteristic.name
	%LevelLabel.text = "Level " + str(characteristic.get_level())
	%CostLabel.text = str(characteristic.next_level_cost())


func _on_gold_value_updated(new_value: int) -> void:
	%UpgradeButton.set_disabled(new_value < characteristic.next_level_cost())
