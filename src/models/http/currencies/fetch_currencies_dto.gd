class_name FetchCurrenciesDto

var gold: int
var diamond: int
var emerald: int
var amethyst: int


func _init(dictionary: Dictionary) -> void:
	gold = dictionary["gold"]
	diamond = dictionary["diamond"]
	emerald = dictionary["emerald"]
	amethyst = dictionary["amethyst"]
