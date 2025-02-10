class_name CharacteristicsStore extends ReactiveStore

var attack_property := ReactiveStoreProperty.new(self, &"attack")
var crit_chance_property := ReactiveStoreProperty.new(self, &"crit_chance")
var crit_damage_property := ReactiveStoreProperty.new(self, &"crit_damage")
var health_property := ReactiveStoreProperty.new(self, &"health")
var resistance_property := ReactiveStoreProperty.new(self, &"resistance")

# Type definitions
var attack: Characteristic:
	get:
		return await attack_property.get_value()
	set(v):
		attack_property.set_value(v)

var crit_chance: Characteristic:
	get:
		return await crit_chance_property.get_value()
	set(v):
		crit_chance_property.set_value(v)

var crit_damage: Characteristic:
	get:
		return await crit_damage_property.get_value()
	set(v):
		crit_damage_property.set_value(v)

var health: Characteristic:
	get:
		return await health_property.get_value()
	set(v):
		health_property.set_value(v)

var resistance: Characteristic:
	get:
		return await resistance_property.get_value()
	set(v):
		resistance_property.set_value(v)


func _init() -> void:
	_initialize_reactive_store(
		CharacteristicsState.get_property_types(), CharacteristicsState.get_initial_state()
	)


# Actions
func set_characteristics(
	_attack: int, _crit_chance: int, _crit_damage: int, _health: int, _resistance: int
) -> void:
	set_properties(
		{
			&"attack": Characteristic.new(_attack),
			&"crit_chance": Characteristic.new(_crit_chance),
			&"crit_damage": Characteristic.new(_crit_damage),
			&"health": Characteristic.new(_health),
			&"resistance": Characteristic.new(_resistance)
		}
	)
