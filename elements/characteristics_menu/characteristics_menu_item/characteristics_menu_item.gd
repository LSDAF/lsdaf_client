extends HBoxContainer

@export var characteristic: Characteristic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characteristic.upgraded.connect(_on_upgraded)
	
	%ValueLabel.text = str(characteristic.current_value()) + ' ' + characteristic.name
	%LevelLabel.text = 'Level ' + str(characteristic.get_level())
	%CostLabel.text = str(characteristic.next_level_cost())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_upgrade_button_button_down() -> void:
	characteristic.upgrade()

func _on_upgraded() -> void:
	%ValueLabel.text = str(characteristic.current_value()) + ' ' + characteristic.name
	%LevelLabel.text = 'Level ' + str(characteristic.get_level())
	%CostLabel.text = str(characteristic.next_level_cost())
