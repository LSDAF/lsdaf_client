extends StoreManager

const CurrenciesStore := preload("res://src/store/stores/currencies/currencies_store.gd")
const CharacteristicsStore := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)
const DifficultyStore := preload("res://src/store/stores/difficulty/difficulty_store.gd")


func _init() -> void:
	print("init")

	# Create instances
	currencies = CurrenciesStore.new()
	characteristics = CharacteristicsStore.new()
	difficulty = DifficultyStore.new()

	# Add stores as children
	add_child(currencies)
	add_child(characteristics)
	add_child(difficulty)

	await initialize()


func reset() -> void:
	_cleanup_stores()

	# Create default instances
	currencies = CurrenciesStore.new()
	characteristics = CharacteristicsStore.new()
	difficulty = DifficultyStore.new()

	# Add as children
	add_child(currencies)
	add_child(characteristics)
	add_child(difficulty)

	await initialize()
