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


static func _prettify_statistic(
	item_statistic: ItemStatistics.ItemStatistics, current_value: float
) -> String:
	var prettified_statistic := ""

	match item_statistic:
		ItemStatistics.ItemStatistics.ATTACK_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.ATTACK_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Attack"])
		ItemStatistics.ItemStatistics.CRIT_CHANCE:
			prettified_statistic = "+{0}% {1}".format([current_value, "Crit. Chance"])
		ItemStatistics.ItemStatistics.CRIT_DAMAGE:
			prettified_statistic = "+{0}% {1}".format([current_value, "Crit. Damage"])
		ItemStatistics.ItemStatistics.HEALTH_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Health"])
		ItemStatistics.ItemStatistics.HEALTH_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Health"])
		ItemStatistics.ItemStatistics.RESISTANCE_ADD:
			prettified_statistic = "+{0} {1}".format([current_value, "Resistance"])
		ItemStatistics.ItemStatistics.RESISTANCE_MULT:
			prettified_statistic = "+{0}% {1}".format([current_value, "Resistance"])
		_:
			prettified_statistic = "UNSUPPORTED"

	return prettified_statistic
