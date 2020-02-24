extends "res://scripts/bag_aware.gd"

var http_client

var enabled = false
var api_location = null
var api_port = null
var api_use_ssl = false

func _initialize():
	self.http_client = HTTPClient.new()

	self.enabled = ProjectSettings.get_setting('tof/online')
	self.api_location = ProjectSettings.get_setting('tof/api_location')
	self.api_port = ProjectSettings.get_setting('tof/api_port')
	self.api_use_ssl = ProjectSettings.get_setting('tof/api_use_ssl')

func getReq(api, resource, expect_json = true):
	return self.make_request(api, resource, HTTPClient.METHOD_GET, null, expect_json)

func post(api, resource, data = "", expect_json = true):
	return self.make_request(api, resource, HTTPClient.METHOD_POST, data, expect_json)


func make_request(api, resource, method, data, expect_json = true):
	var result = {
		'status' : null,
		'response_code' : 0,
		'data' : {}
	}

	if not self.enabled:
		result['status'] = 'error'
		result['message'] = 'Online functions are disabled'
		return result

	var err = self.http_client.connectALT(api, self.api_port, self.api_use_ssl)

	if err != OK:
		result['status'] = 'error'
		result['message'] = 'Could not open connection'
		return result

	while self.http_client.get_status() == HTTPClient.STATUS_CONNECTING or self.http_client.get_status() == HTTPClient.STATUS_RESOLVING:
		self.http_client.poll()
		OS.delay_msec(500)

	if self.http_client.get_status() != HTTPClient.STATUS_CONNECTED:
		result['status'] = 'error'
		result['message'] = 'Could not connect'
		return result

	var headers = [
		"User-Agent: ToF/" + self.bag.root.version_short,
		"Accept: */*"
	]
	if data:
		headers.append("Content-Type: application/json")
		err = self.http_client.request(method, resource, headers, data)
	else:
		err = self.http_client.request(method, resource, headers)

	if err != OK:
		result['status'] = 'error'
		result['message'] = 'Could not make request'
		return result

	while self.http_client.get_status() == HTTPClient.STATUS_REQUESTING:
		self.http_client.poll()
		OS.delay_msec(500)

	if self.http_client.get_status() != HTTPClient.STATUS_BODY and self.http_client.get_status() != HTTPClient.STATUS_CONNECTED:
		result['status'] = 'error'
		result['message'] = 'Could not poll request'
		return result

	if (self.http_client.has_response()):
		result['headers'] = self.http_client.get_response_headers_as_dictionary()
		result['response_code'] = self.http_client.get_response_code()

		var read_buffer = PoolByteArray()
		var chunk

		while self.http_client.get_status() == HTTPClient.STATUS_BODY:
			self.http_client.poll()
			chunk = self.http_client.read_response_body_chunk()
			if chunk.size() == 0:
				OS.delay_usec(1000)
			else:
				read_buffer = read_buffer + chunk

		var response_text = read_buffer.get_string_from_ascii()

		if expect_json:
			result['data'].parse_json(response_text)
		else:
			result['data'] = response_text

	if result['data'].has('error'):
		result['status'] = 'error'
	else:
		result['status'] = 'ok'

	return result
