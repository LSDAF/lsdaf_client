extends StoreManager

const CurrenciesStore := preload("res://src/store/stores/currencies/currencies_store.gd")
const CharacteristicsStore := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)
const DifficultyStore := preload("res://src/store/stores/difficulty/difficulty_store.gd")

# Application-specific store instances
var currencies: CurrenciesStore
var characteristics: CharacteristicsStore
var difficulty: DifficultyStore


func _init() -> void:
	# Create instances
	currencies = CurrenciesStore.new()
	characteristics = CharacteristicsStore.new()
	difficulty = DifficultyStore.new()

	# Register stores with the manager
	register_store(currencies)
	register_store(characteristics)
	register_store(difficulty)

	await initialize()


func reset() -> void:
	_cleanup_stores()

	# Create default instances
	currencies = CurrenciesStore.new()
	characteristics = CharacteristicsStore.new()
	difficulty = DifficultyStore.new()

	# Register stores with the manager
	register_store(currencies)
	register_store(characteristics)
	register_store(difficulty)

	await initialize()


# Helper functions to access stores
func get_currencies() -> CurrenciesStore:
	return currencies


func get_characteristics() -> CharacteristicsStore:
	return characteristics


func get_difficulty() -> DifficultyStore:
	return difficulty
