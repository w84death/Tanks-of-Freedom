extends "res://scripts/bag_aware.gd"

var MAPS_URL = "/maps"

var ONLINE_MAP_EXTENSION = ".remote"

var last_upload_code

func can_transfer():
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return false
	return true

func upload_map(data, name):
	var message = self.bag.online_player.get_basic_auth_json()
	var serialized_json = ""

	message['data'] = data
	message['data']['name'] = name

	serialized_json = message.to_json()

	var result = self.bag.online_request.post(self.bag.online_request.api_location, self.MAPS_URL, serialized_json)

	if result['status'] != 'ok':
		return false

	var metadata = {
		'name' : name
	}
	self.save_map(data, result['data']['code'], metadata)

	self.last_upload_code = result['data']['code']

	return true

func download_map(code):
	if not code:
		return false

	if self.bag.map_list.has_remote_map(code):
		return true

	var result = self.bag.online_request.get(self.bag.online_request.api_location, self.MAPS_URL + "/" + code + ".json")
	if result['status'] != 'ok':
		return false

	if not result.has('data') or not result['data'].has('data'):
		return false

	var metadata = {
		'name' : result['data']['data']['name']
	}
	self.save_map(result['data']['data'], code, metadata)

	return true


func download_map_async_background(code):
	if not code:
		return

	if self.bag.map_list.has_remote_map(code):
		return

	var callbacks = {
		"handle_200" : "add_map_data_background",
		"handle_error" : "download_failed"
	}

	self.bag.online_request_async.get(self.bag.online_request.api_location, self.MAPS_URL + "/" + code + ".json", self, callbacks)

func add_map_data_background(response):
	if response['status'] != 'ok':
		return false

	if not response.has('data') or not response['data'].has('data'):
		return false

	var metadata = {
		'name' : response['data']['data']['name']
	}
	var code = response['data']['code']
	self.save_map(response['data']['data'], code, metadata)
	self.bag.controllers.online_menu_controller.multiplayer.download_stock_maps()

func download_failed(response):
	return #dummy

func save_map(data, code, metadata = {}):
	var remote_file_name = self.get_remote_file_name(code)
	self.bag.file_handler.write(remote_file_name, data)
	self.bag.map_list.store_remote_map(code, metadata)

func get_remote_file_name(code):
	return "user://" + code + self.ONLINE_MAP_EXTENSION
