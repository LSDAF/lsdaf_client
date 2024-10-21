class_name CurrenciesDto

var gold: int
var diamonds: int
var emeralds: int
var amethysts: int


func _init(dictionary: Dictionary) -> void:
	if dictionary.has("gold"):
		gold = dictionary["gold"]

	if dictionary.has("diamonds"):
		diamonds = dictionary["diamonds"]

	if dictionary.has("emeralds"):
		emeralds = dictionary["emeralds"]

	if dictionary.has("amethysts"):
		amethysts = dictionary["amethysts"]
