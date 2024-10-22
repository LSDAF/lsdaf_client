class_name FetchCurrenciesDto

var gold: int
var diamonds: int
var emeralds: int
var amethysts: int


func _init(dictionary: Dictionary) -> void:
	gold = dictionary["gold"]
	diamonds = dictionary["diamonds"]
	emeralds = dictionary["emeralds"]
	amethysts = dictionary["amethysts"]