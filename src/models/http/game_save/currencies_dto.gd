class_name CurrenciesDto

var gold: int
var diamond: int
var emerald: int
var amethyst: int


func _init(dictionary: Dictionary) -> void:
	if dictionary.has("gold"):
		gold = dictionary["gold"]

	if dictionary.has("diamond"):
		diamond = dictionary["diamond"]

	if dictionary.has("emerald"):
		emerald = dictionary["emerald"]

	if dictionary.has("amethyst"):
		amethyst = dictionary["amethyst"]
