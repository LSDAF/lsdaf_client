class_name HttpEventHandler
extends Node

var _queue: Queue
var _prioritary_queue: Queue


func process_queue() -> void:
	while not _queue.is_empty():
		var request: HttpRequest = _queue.dequeue()
		var result: bool = await _process_event(request)
		if result:
			print("Function called successfully.")
			break
		else:
			print("Error while calling the function.")


func enqueue_event(request: HttpRequest) -> void:
	if request.get_prioritary():
		_prioritary_queue.enqueue(request)
	else:
		_queue.enqueue(request)


func _process_event(request: HttpRequest) -> bool:
	var callable: Callable = request.get_function()
	var nb_retries: int = request.get_nb_retries()

	var final_result: bool = false

	for i in range(nb_retries):
		var response: HTTPResult = callable.call()
		if response.success():
			final_result = true
			break
		# waits for 5 seconds before retrying
		await get_tree().create_timer(5).timeout

	return final_result


func _init(queue: Queue, prioritary_queue: Queue) -> void:
	_queue = queue
	_prioritary_queue = prioritary_queue
