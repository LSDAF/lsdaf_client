extends Object

class_name Queue

var _data: Array = []


# Add an item to the queue
func enqueue(item: Variant) -> void:
	_data.append(item)

# Remove and return the item at the front of the queue
func dequeue() -> Variant:
	if is_empty():
		push_error("Queue is empty. Cannot dequeue.")
		return null
	return _data.pop_front()

# Peek at the front item without removing it
func peek() -> Variant:
	if is_empty():
		push_error("Queue is empty. Cannot peek.")
		return null
	return _data[0]

# Check if the queue is empty
func is_empty() -> bool:
	return _data.size() == 0

# Get the size of the queue
func size() -> int:
	return _data.size()

# Clear the queue
func clear() -> void:
	_data.clear()
