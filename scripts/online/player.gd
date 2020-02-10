extends "res://scripts/bag_aware.gd"

var player_id = null
var player_pin = null

var REGISTER_URL = "/players"

func _initialize():
	self.player_id = self.bag.root.settings['online_player_id']
	self.player_pin = self.bag.root.settings['online_player_pin']

func request_player_id():
	if not self.bag.online_request.enabled or self.player_id != null:
		return

	var response = self.bag.online_request.post(self.bag.online_request.api_location, self.REGISTER_URL)

	if response['status'] != 'ok':
		return

	self.player_id = response['data']['id']
	self.player_pin = response['data']['pin']
	self.bag.root.settings['online_player_id'] = self.player_id
	self.bag.root.settings['online_player_pin'] = self.player_pin
	self.bag.root.write_settings_to_file()

func request_player_id_async():
	if not self.bag.online_request.enabled or self.player_id != null:
		return

	var callbacks = {
		"handle_200" : "_request_player_id_response",
		"handle_error" : "_request_player_id_response"
	}
	self.bag.online_request_async.post(self.bag.online_request.api_location, self.REGISTER_URL, "", self, callbacks)

func _request_player_id_response(response):
	if response['status'] == 'ok':
		self.player_id = response['data']['id']
		self.player_pin = response['data']['pin']
		self.bag.root.settings['online_player_id'] = self.player_id
		self.bag.root.settings['online_player_pin'] = self.player_pin
		self.bag.root.write_settings_to_file()

	self.bag.controllers.online_menu_controller.online_register_done()

func get_player_id():
	if not self.bag.online_request.enabled:
		return null

	return self.player_id

func get_basic_auth_json():
	return {
		'player_id' : self.player_id,
		'player_pin' : self.player_pin
	}
