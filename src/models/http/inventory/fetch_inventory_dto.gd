class_name FetchInventoryDto

var items: Array[InventoryItemDto]


func _init(dictionary: Dictionary) -> void:
	for item: Dictionary in dictionary["items"]:
		items.push_back(InventoryItemDto.new(item))
