class_name GameSaveService

var _characteristics_api: CharacteristicsApi
var _currency_api: CurrenciesApi
var _inventory_api: InventoryApi
var _stage_api: StageApi
var _clock_service: ClockService
var _characteristics_store: CharacteristicsStore
var _currencies_store: CurrenciesStore
var _inventory_service: InventoryService
var _stage_service: StageService
var _game_save_data: GameSaveData


func _init(
	characteristics_api: CharacteristicsApi,
	currency_api: CurrenciesApi,
	inventory_api: InventoryApi,
	stage_api: StageApi,
	clock_service: ClockService,
	characteristics_store: CharacteristicsStore,
	currencies_store: CurrenciesStore,
	inventory_service: InventoryService,
	stage_service: StageService,
	game_save_data: GameSaveData,
) -> void:
	_characteristics_api = characteristics_api
	_currency_api = currency_api
	_inventory_api = inventory_api
	_stage_api = stage_api
	_clock_service = clock_service
	_characteristics_store = characteristics_store
	_currencies_store = currencies_store
	_inventory_service = inventory_service
	_stage_service = stage_service
	_game_save_data = game_save_data


func get_game_save_id() -> String:
	return _game_save_data._game_save_id


func load_game_save(game_save_id: String) -> void:
	_game_save_data._game_save_id = game_save_id

	var fetched_characteristics := await _characteristics_api.fetch_game_save_characteristics(
		_game_save_data._game_save_id, _on_fetch_characteristics_error
	)
	_characteristics_store.set_characteristics_level(
		fetched_characteristics.attack,
		fetched_characteristics.crit_chance,
		fetched_characteristics.crit_damage,
		fetched_characteristics.health,
		fetched_characteristics.resistance
	)

	var fetched_currencies := await _currency_api.fetch_game_save_currencies(
		_game_save_data._game_save_id, _on_fetch_currencies_error
	)
	_currencies_store.set_currencies(
		fetched_currencies.gold,
		fetched_currencies.diamond,
		fetched_currencies.emerald,
		fetched_currencies.amethyst
	)

	var fetched_inventory := await _inventory_api.fetch_game_save_inventory(
		_game_save_data._game_save_id, _on_fetch_inventory_error
	)
	_inventory_service.set_inventory_from_fetch_inventory_dto(fetched_inventory)

	var fetched_stage := await _stage_api.fetch_game_save_stage(
		_game_save_data._game_save_id, _on_fetch_stage_error
	)
	_stage_service.set_current_stage(fetched_stage.current_stage)
	_stage_service.set_max_stage(fetched_stage.max_stage)


func save_game() -> void:
	var success := (
		await _save_currencies() and await _save_stage() and await _save_characteristics()
	)

	if success:
		_game_save_data._last_save_time = _clock_service.get_unix_time_from_system()
		Services.toaster.toast("Game saved.")
		print("Game Saved")
	else:
		Services.toaster.toast("Failed to save game.")
		print("Failed to save game.")


func _save_characteristics() -> bool:
	var update_characteristics_dto := (
		UpdateCharacteristicsDto
		. new(
			{
				"attack": (await _characteristics_store.attack_property.get_value()).get_level(),
				"crit_chance":
				(await _characteristics_store.crit_chance_property.get_value()).get_level(),
				"crit_damage":
				(await _characteristics_store.crit_damage_property.get_value()).get_level(),
				"health": (await _characteristics_store.health_property.get_value()).get_level(),
				"resistance":
				(await _characteristics_store.resistance_property.get_value()).get_level(),
			}
		)
	)

	return await _characteristics_api.update_game_save_characteristics(
		_game_save_data._game_save_id, update_characteristics_dto, _on_save_characteristics_error
	)


func _save_currencies() -> bool:
	var update_currencies_dto := (
		UpdateCurrenciesDto
		. new(
			{
				"gold": await _currencies_store.gold_property.get_value(),
				"diamond": await _currencies_store.diamond_property.get_value(),
				"emerald": await _currencies_store.emerald_property.get_value(),
				"amethyst": await _currencies_store.amethyst_property.get_value(),
			}
		)
	)

	return await _currency_api.update_game_save_currencies(
		Data.game_save._game_save_id, update_currencies_dto, _on_save_currencies_error
	)


func _save_stage() -> bool:
	var update_stage_dto := (
		UpdateStageDto
		. new(
			{
				"current_stage": _stage_service.get_current_stage(),
				"max_stage": _stage_service.get_max_stage(),
			}
		)
	)

	return await _stage_api.update_game_save_stage(
		_game_save_data._game_save_id, update_stage_dto, _on_save_stage_error
	)


func _on_fetch_characteristics_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch characteristics.")
	print(response)


func _on_fetch_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch currencies.")
	print(response)


func _on_fetch_inventory_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch inventory.")
	print(response)


func _on_fetch_stage_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch stage.")
	print(response)


func _on_save_characteristics_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save characteristics.")
	print(response)


func _on_save_currencies_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save currencies.")
	print(response)


func _on_save_stage_error(response: Variant) -> void:
	Services.toaster.toast("Failed to save stage.")
	print(response)
