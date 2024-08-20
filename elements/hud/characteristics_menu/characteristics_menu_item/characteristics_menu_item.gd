extends HBoxContainer

@export var characteristic: Characteristic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characteristic.upgraded.connect(_on_upgraded)
	Currencies.gold.updated.connect(_on_gold_value_updated)

	%ValueLabel.text = str(characteristic.current_value()) + " " + characteristic.name
	%LevelLabel.text = "Level " + str(characteristic.get_level())
	%UpgradeButton.set_disabled(Currencies.gold.get_value() < characteristic.next_level_cost())
	%CostLabel.text = str(characteristic.next_level_cost())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrade_button_button_down() -> void:
	Currencies.gold.update_value(-characteristic.next_level_cost())
	characteristic.upgrade()


func _on_upgraded() -> void:
	%ValueLabel.text = str(characteristic.current_value()) + " " + characteristic.name
	%LevelLabel.text = "Level " + str(characteristic.get_level())
	%CostLabel.text = str(characteristic.next_level_cost())


func _on_gold_value_updated(new_value: int) -> void:
	%UpgradeButton.set_disabled(new_value < characteristic.next_level_cost())
