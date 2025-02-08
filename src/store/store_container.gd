class_name StoreContainer extends StoreManager


func _init(
	_currencies: CurrenciesStore,
	_characteristics: CharacteristicsStore,
	_difficulty: DifficultyStore
) -> void:
	currencies = _currencies
	characteristics = _characteristics
	difficulty = _difficulty
	_validate_stores()
