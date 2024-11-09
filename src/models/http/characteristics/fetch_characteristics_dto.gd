class_name FetchCharacteristicsDto

var attack: int
var crit_chance: int
var crit_damage: int
var health: int
var resistance: int


func _init(dictionary: Dictionary) -> void:
	attack = dictionary["attack"]
	crit_chance = dictionary["crit_chance"]
	crit_damage = dictionary["crit_damage"]
	health = dictionary["health"]
	resistance = dictionary["resistance"]
