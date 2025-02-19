class_name ItemStat

var statistic: ItemStatistics.ItemStatistics
var base_value: float


static func to_dictionary(stat: ItemStat) -> Dictionary:
	return {
		"statistic": ItemStatistics.ItemStatistics.keys()[stat.statistic],
		"base_value": stat.base_value
	}
