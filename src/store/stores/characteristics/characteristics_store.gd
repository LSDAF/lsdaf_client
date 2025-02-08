class_name CharacteristicsStore extends ReactiveStore

var attack_property := ReactiveStoreProperty.new(self, &"attack")
var crit_chance_property := ReactiveStoreProperty.new(self, &"crit_chance")
var crit_damage_property := ReactiveStoreProperty.new(self, &"crit_damage")
var health_property := ReactiveStoreProperty.new(self, &"health")
var resistance_property := ReactiveStoreProperty.new(self, &"resistance")

# Type definitions
var attack: int:
	get:
		return await attack_property.get_value()
	set(v):
		attack_property.set_value(v)

var crit_chance: int:
	get:
		return await crit_chance_property.get_value()
	set(v):
		crit_chance_property.set_value(v)

var crit_damage: int:
	get:
		return await crit_damage_property.get_value()
	set(v):
		crit_damage_property.set_value(v)

var health: int:
	get:
		return await health_property.get_value()
	set(v):
		health_property.set_value(v)

var resistance: int:
	get:
		return await resistance_property.get_value()
	set(v):
		resistance_property.set_value(v)


func _init() -> void:
	_define_properties(
		CharacteristicsState.get_property_types(), CharacteristicsState.get_initial_state()
	)


# Actions
func set_characteristics(
	_attack: int, _crit_chance: int, _crit_damage: int, _health: int, _resistance: int
) -> void:
	set_properties(
		{
			&"attack": _attack,
			&"crit_chance": _crit_chance,
			&"crit_damage": _crit_damage,
			&"health": _health,
			&"resistance": _resistance
		}
	)
