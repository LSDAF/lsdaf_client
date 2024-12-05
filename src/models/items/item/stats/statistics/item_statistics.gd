class_name ItemStatistics

enum ItemStatistics {
	ATTACK_ADD,
	ATTACK_MULT,
	CRIT_CHANCE,
	CRIT_DAMAGE,
	HEALTH_ADD,
	HEALTH_MULT,
	RESISTANCE_ADD,
	RESISTANCE_MULT,
}


static func value_of(string: String) -> ItemStatistics.ItemStatistics:
	match string:
		"attack_add":
			return ItemStatistics.ItemStatistics.ATTACK_ADD
		"attack_mult":
			return ItemStatistics.ItemStatistics.ATTACK_MULT
		"crit_chance":
			return ItemStatistics.ItemStatistics.CRIT_CHANCE
		"crit_damage":
			return ItemStatistics.ItemStatistics.CRIT_DAMAGE
		"health_add":
			return ItemStatistics.ItemStatistics.HEALTH_ADD
		"health_mult":
			return ItemStatistics.ItemStatistics.HEALTH_MULT
		"resistance_add":
			return ItemStatistics.ItemStatistics.RESISTANCE_ADD
		"resistance_mult":
			return ItemStatistics.ItemStatistics.RESISTANCE_MULT
		_:
			push_error("Invalid item statistic, defaulting to attack_add")
			return ItemStatistics.ItemStatistics.ATTACK_ADD
