class_name ApiClient
extends Node


func _generate_headers(
	upsert_headers: Dictionary, auth: bool, method := HTTPClient.METHOD_GET
) -> PackedStringArray:
	var building_headers: Dictionary

	if auth:
		building_headers["Authorization"] = "Bearer {0}".format(
			[Services.user_local_data.get_access_token()]
		)

	if method == HTTPClient.METHOD_POST:
		building_headers["Content-Type"] = "application/json"

	var headers: PackedStringArray = []

	for key: String in building_headers:
		headers.append("{0}: {1}".format([key, building_headers[key]]))

	for key: String in upsert_headers:
		headers.append("{0}: {1}".format([key, upsert_headers[key]]))

	return headers


func _log_error(url: String, response: HTTPResult) -> void:
	if !response.success() or response.status_err():
		var error := "{0}: Received status code [ {1} ]\nBody:\n{2}".format(
			[url, str(response.status), response.body_as_string()]
		)
		push_error(error)


func fetch(url: String, auth: bool, upsert_headers: Dictionary = {}) -> HTTPResult:
	var headers := _generate_headers(upsert_headers, auth)

	var response: HTTPResult = await Http.http_client.http.async_request(
		url, headers, HTTPClient.METHOD_GET
	)

	_log_error(url, response)

	return response


func post(
	url: String, auth: bool, body: Dictionary = {}, upsert_headers: Dictionary = {}
) -> HTTPResult:
	var headers := _generate_headers(upsert_headers, auth, HTTPClient.METHOD_POST)
	var request_data := JSON.stringify(body)

	var response: HTTPResult = await Http.http_client.http.async_request(
		url, headers, HTTPClient.METHOD_POST, request_data
	)

	_log_error(url, response)

	return response
