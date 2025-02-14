extends StoreManager

const CurrenciesStore := preload("res://src/store/stores/currencies/currencies_store.gd")
const CharacteristicsStore := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)
const DifficultyStore := preload("res://src/store/stores/difficulty/difficulty_store.gd")
const StageStore := preload("res://src/store/stores/stage/stage_store.gd")

# Application-specific store instances
var currencies: CurrenciesStore
var characteristics: CharacteristicsStore
var difficulty: DifficultyStore
var stage: StageStore


func _init() -> void:
	reset()


func reset() -> void:
	_cleanup_stores()

	# Create default instances
	currencies = CurrenciesStore.new()
	characteristics = CharacteristicsStore.new()
	difficulty = DifficultyStore.new()
	stage = StageStore.new()

	# Register stores with the manager
	register_store(currencies)
	register_store(characteristics)
	register_store(difficulty)
	register_store(stage)

	await initialize()
