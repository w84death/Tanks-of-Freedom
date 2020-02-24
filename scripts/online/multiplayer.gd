extends "res://scripts/bag_aware.gd"

const MATCHES_LIST_URL = "/matches/my"
const MATCH_CREATE_URL = "/matches"
const MATCH_DETAILS_URL = "/match/"
const MATCH_JOIN_URL = "/match/join/"
const MATCH_ABANDON_URL = "/match/abandon/"
const MATCH_TURN_URL = "/match/turn/"

const REPLAY_INTERVAL = 0.5

func get_matches_list(bound_object, bound_method):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var callbacks = {
		"handle_200" : bound_method,
		"handle_error" : bound_method
	}

	var message = self.bag.online_player.get_basic_auth_json()
	var serialized_json = message.to_json()

	self.bag.online_request_async.post(self.bag.online_request.api_location, self.MATCHES_LIST_URL, serialized_json, bound_object, callbacks)

func create_new_match(map_code, side, bound_object, bound_method_success, bound_method_fail):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var callbacks = {
		"handle_200" : bound_method_success,
		"handle_error" : bound_method_fail
	}

	var message = self.bag.online_player.get_basic_auth_json()
	message['map_code'] = map_code
	message['side'] = side
	var serialized_json = message.to_json()

	self.bag.online_request_async.post(self.bag.online_request.api_location, self.MATCH_CREATE_URL, serialized_json, bound_object, callbacks)

func fetch_match_details(code, bound_object, bound_method_success, bound_method_fail):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var url = self.MATCH_DETAILS_URL + code + ".json"

	var callbacks = {
		"handle_200" : bound_method_success,
		"handle_error" : bound_method_fail
	}

	self.bag.online_request_async.get(self.bag.online_request.api_location, url, bound_object, callbacks)

func join_match(code, bound_object, bound_method_success, bound_method_fail):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var url = self.MATCH_JOIN_URL + code + ".json"

	var callbacks = {
		"handle_200" : bound_method_success,
		"handle_400" : bound_method_fail,
		"handle_403" : bound_method_fail,
		"handle_500" : bound_method_fail,
		"handle_error" : bound_method_fail
	}

	var message = self.bag.online_player.get_basic_auth_json()
	var serialized_json = message.to_json()

	self.bag.online_request_async.post(self.bag.online_request.api_location, url, serialized_json, bound_object, callbacks)


func abandon_match(code, bound_object, bound_method_success, bound_method_fail):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var url = self.MATCH_ABANDON_URL + code + ".json"

	var callbacks = {
		"handle_200" : bound_method_success,
		"handle_403" : bound_method_fail,
		"handle_error" : bound_method_fail
	}

	var message = self.bag.online_player.get_basic_auth_json()
	var serialized_json = message.to_json()

	self.bag.online_request_async.post(self.bag.online_request.api_location, url, serialized_json, bound_object, callbacks)

func load_match_state(code, bound_object, bound_method_success, bound_method_fail):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var url = self.MATCH_DETAILS_URL + code + ".json"

	var callbacks = {
		"handle_200" : bound_method_success,
		"handle_403" : bound_method_fail,
		"handle_error" : bound_method_fail
	}

	var message = self.bag.online_player.get_basic_auth_json()
	var serialized_json = message.to_json()

	self.bag.online_request_async.post(self.bag.online_request.api_location, url, serialized_json, bound_object, callbacks)


func upload_turn_state(code, turn_data, bound_object, bound_method_success, bound_method_fail):
	if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
		return

	var url = self.MATCH_TURN_URL + code + ".json"

	var callbacks = {
		"handle_200" : bound_method_success,
		"handle_400" : bound_method_fail,
		"handle_403" : bound_method_fail,
		"handle_500" : bound_method_fail,
		"handle_error" : bound_method_fail
	}

	var message = self.bag.online_player.get_basic_auth_json()
	message['turn_data'] = turn_data

	var serialized_json = message.to_json()

	self.bag.online_request_async.post(self.bag.online_request.api_location, url, serialized_json, bound_object, callbacks)
	self.bag.controllers.online_menu_controller.refreshed = false









func load_game_from_state():
	var state_copy = self.bag.match_state.current_loaded_multiplayer_state
	var final_state = self.bag.match_state.get_final_state()
	var map_code = self.bag.match_state.current_loaded_multiplayer_state['map_code']
	var active_player = self._get_active_player(state_copy)

	self.bag.root.unload_map()

	self._apply_player_sides_from_state()

	if final_state.size() > 0:
		self.bag.saving.apply_multiplayer_state(final_state, active_player)
		self.bag.root.load_map('workshop', map_code, true, true, self, "post_load_game_from_state")
	else:
		self.bag.root.load_map('workshop', map_code, false, true, self, "post_load_game_from_state")

	self.bag.match_state.current_loaded_multiplayer_state = state_copy
	self.bag.match_state.is_multiplayer = true
	self.bag.match_state.reset_actions_taken()

func post_load_game_from_state():
	if self.bag.match_state.current_loaded_multiplayer_state['player_status'] == 1:
		self.start_polling_state(self.bag.match_state.current_loaded_multiplayer_state['join_code'])

func load_replay_from_state():
	var state_copy = self.bag.match_state.current_loaded_multiplayer_state
	var initial_state = self.bag.match_state.get_initial_state()
	var map_code = self.bag.match_state.current_loaded_multiplayer_state['map_code']
	var active_player = (int(state_copy['player_side']) + 1) % 2

	self.bag.root.unload_map()

	self._apply_player_sides_from_state()

	if initial_state.size() > 0:
		self.bag.saving.apply_multiplayer_state(initial_state, active_player)
		self.bag.root.load_map('workshop', map_code, true, true, self, "post_load_replay_from_state")
	else:
		self.bag.root.load_map('workshop', map_code, false, true, self, "post_load_replay_from_state")

	self.bag.match_state.current_loaded_multiplayer_state = state_copy
	self.bag.match_state.is_multiplayer = true
	self.bag.match_state.reset_actions_taken()

func post_load_replay_from_state():
	self.bag.root.lock_for_cpu()

	self.bag.root.action_controller.refill_ap()
	self.bag.root.action_controller.show_bonus_ap()
	self.start_reproducing_moves(self.bag.match_state.current_loaded_multiplayer_state['join_code'])


func _get_active_player(state):
	if state['player_side'] == 0:
		if state['player_status'] == 0:
			return 0
		else:
			return 1
	else:
		if state['player_status'] == 0:
			return 1
		else:
			return 0

func _apply_player_sides_from_state():
	var player_side = self.bag.match_state.current_loaded_multiplayer_state['player_side']

	self.bag.root.settings['cpu_0'] = true
	self.bag.root.settings['cpu_1'] = true
	self.bag.root.settings['cpu_' + str(player_side)] = false
	self.bag.root.settings['turns_cap'] = 0







func update_turn_state():
	var updated_state = self.get_updated_turn_state()
	var match_code = self.bag.match_state.current_loaded_multiplayer_state['join_code']

	self.upload_turn_state(match_code, updated_state, self, "finished_updating_state", "server_call_state_went_bad")


func end_game():
	var updated_state = self.get_updated_turn_state()
	updated_state['win'] = true
	var match_code = self.bag.match_state.current_loaded_multiplayer_state['join_code']

	self.upload_turn_state(match_code, updated_state, self, "end_game_success", "server_call_state_went_bad")

func end_game_success(response):
	return # stub method


func finished_updating_state(response):
	self.start_polling_state(response['data']['join_code'])

func server_call_state_went_bad(response):
	self.bag.root.show_menu()
	self.bag.root.unload_map()
	self.bag.controllers.online_menu_controller.refreshed = false
	self.bag.controllers.menu_controller.show_online_menu()

func get_updated_turn_state():
	var updated_state = {
		'initial_state': self.bag.match_state.get_final_state(),
		'moves': self.bag.match_state.actions_taken,
		'final_state': self.bag.saving.get_current_state()
	}

	return updated_state



func start_polling_state(match_code):
	self.bag.root.hud_controller.update_cinematic_label(tr('MSG_OPPONENT_WAIT'))
	self.bag.match_state.is_polling = true

	self.bag.match_state.polling_counter = 0
	self.polling_step([match_code])


func polling_step(match_code):
	match_code = match_code[0]
	if not self.bag.match_state.current_loaded_multiplayer_state.has('join_code'):
		return
	if self.bag.match_state.current_loaded_multiplayer_state['join_code'] != match_code:
		return

	self.bag.root.hud_controller.cinematic_progress.set_frame(self.bag.match_state.polling_counter)
	if self.bag.match_state.polling_counter == self.bag.match_state.POLLING_INTERVAL:
		self.poll_state(match_code)
		return
	self.bag.match_state.polling_counter = self.bag.match_state.polling_counter + 1
	self.bag.timers.set_timeout(1, self, 'polling_step', [match_code])

func poll_state(match_code):
	self.bag.root.hud_controller.update_cinematic_label(tr('MSG_CHECKING_STATE'))
	var updated_state = self.load_match_state(match_code, self, 'finished_polling_state', 'server_call_state_went_bad')

func finished_polling_state(response):
	var data = response['data']
	var match_code = data['join_code']

	if not self.bag.match_state.is_multiplayer:
		return

	if self.bag.match_state.current_loaded_multiplayer_state['join_code'] != match_code:
		return

	if data['player_status'] == 0:
		self.bag.match_state.current_loaded_multiplayer_state = data
		if self.bag.match_state.is_replay_available():
			self.bag.root.action_controller.refill_ap()
			self.bag.root.action_controller.show_bonus_ap()
			self.start_reproducing_moves(match_code)
		else:
			self.update_turn_with_polled_data()
			self.bag.root.action_controller.switch_to_player(data['player_side'], false)
	elif data['player_status'] == 2:
		self.bag.match_state.is_multiplayer = true
		self.bag.match_state.current_loaded_multiplayer_state = data
		self.update_turn_with_polled_data()
		self.bag.root.unlock_for_player()
		self.bag.root.action_controller.end_game(data['player_side'])
	elif data['player_status'] == 3:
		self.bag.match_state.is_multiplayer = true
		self.bag.match_state.current_loaded_multiplayer_state = data
		self.update_turn_with_polled_data()
		self.bag.root.unlock_for_player()
		self.bag.root.action_controller.end_game((int(data['player_side']) + 1) % 2)
	else:
		self.bag.match_state.polling_counter = 0
		self.bag.root.hud_controller.update_cinematic_label(tr('MSG_OPPONENT_WAIT'))
		self.polling_step([match_code])


func update_turn_with_polled_data():
	var final_state = self.bag.match_state.get_final_state()
	if final_state.size() == 0:
		return
	var active_player = self.bag.match_state.current_loaded_multiplayer_state['player_side']
	self.bag.saving.apply_multiplayer_state(final_state, active_player)

	self.bag.saving.load_map_state()
	self.bag.saving.apply_saved_ground()
	self.bag.saving.apply_saved_buildings()
	self.bag.saving.apply_saved_environment_settings()
	self.bag.root.action_controller.positions.refresh()
	self.bag.root.action_controller.refresh_abstract_map()

func start_reproducing_moves(match_code):
	self.bag.root.hud_controller.update_cinematic_label(tr('LABEL_REPLAYING_MOVES'))
	self.bag.timers.set_timeout(self.REPLAY_INTERVAL, self, 'replay_step', [0, match_code, false])

func replay_step(args):
	var action = args[0]
	var match_code = args[1]
	var execute = args[2]
	if not self.bag.match_state.current_loaded_multiplayer_state.has('join_code'):
		return
	if self.bag.match_state.current_loaded_multiplayer_state['join_code'] != match_code:
		return

	if self.bag.camera.panning or self.bag.root.is_paused:
		self.bag.timers.set_timeout(self.REPLAY_INTERVAL, self, 'replay_step', args)
		return

	var moves = self.bag.match_state.get_replay_moves()
	var current_move = moves[action]
	self.bag.root.hud_controller.update_cpu_progress(moves.size() - action , moves.size())

	if execute:
		self.perform_action(current_move)
	else:
		self.move_camera_to_action(current_move)
		self.bag.timers.set_timeout(self.REPLAY_INTERVAL, self, 'replay_step', [action, match_code, true])
		return


	action = action + 1
	if action < moves.size():
		self.bag.timers.set_timeout(self.REPLAY_INTERVAL, self, 'replay_step', [action, match_code, false])
	else:
		self.bag.timers.set_timeout(self.REPLAY_INTERVAL, self, 'end_replay')


func end_replay():
	self.update_turn_with_polled_data()
	self.bag.root.action_controller.local_end_turn()

func move_camera_to_action(move):
	var positionVAR
	if move['action'] == 'spawn':
		positionVAR = move['from']
	elif move['action'] == 'move':
		positionVAR = move['from']
	elif move['action'] == 'capture':
		positionVAR = move['who']
	elif move['action'] == 'attack':
		positionVAR = move['who']

	positionVAR = Vector2(positionVAR[0], positionVAR[1])
	self.bag.camera.move_to_map(positionVAR)
	self.bag.root.action_controller.set_active_field(positionVAR)


func perform_action(move):
	var positionVAR
	print(move)
	if move['action'] == 'spawn':
		self.bag.root.action_controller.spawn_unit_from_active_building()
	elif move['action'] == 'move':
		positionVAR = move['to']
		positionVAR = Vector2(positionVAR[0], positionVAR[1])
		self.bag.root.action_controller.handle_action(positionVAR)
	elif move['action'] == 'capture':
		positionVAR = move['what']
		positionVAR = Vector2(positionVAR[0], positionVAR[1])
		self.bag.root.action_controller.handle_action(positionVAR)
	elif move['action'] == 'attack':
		positionVAR = move['whom']
		positionVAR = Vector2(positionVAR[0], positionVAR[1])
		self.bag.root.action_controller.handle_action(positionVAR)

