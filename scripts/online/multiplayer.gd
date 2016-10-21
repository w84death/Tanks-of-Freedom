
const MATCHES_LIST_URL = "/matches/my"
const MATCH_CREATE_URL = "/matches"
const MATCH_DETAILS_URL = "/match/"
const MATCH_JOIN_URL = "/match/join/"
const MATCH_ABANDON_URL = "/match/abandon/"
const MATCH_TURN_URL = "/match/turn/"

var bag

func _init_bag(bag):
    self.bag = bag


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









func load_game_from_state():
    var state_copy = self.bag.match_state.current_loaded_multiplayer_state
    var final_state = self.bag.match_state.get_final_state()
    var map_code = self.bag.match_state.current_loaded_multiplayer_state['map_code']

    self._apply_player_sides_from_state()

    if final_state.size() > 0:
        self.bag.saving.apply_multiplayer_state(final_state, self._get_active_player(state_copy))
        self.bag.root.load_map('workshop', map_code, true, true)
    else:
        self.bag.root.load_map('workshop', map_code, false, true)

    self.bag.match_state.current_loaded_multiplayer_state = state_copy
    self.bag.root.ai_timer.reset_state()
    self.bag.match_state.is_multiplayer = true
    self.bag.match_state.reset_actions_taken()

func load_replay_from_state():
    return


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

    self.upload_turn_state(match_code, updated_state, self, "finished_updating_state", "updating_state_went_bad")


func finished_updating_state(response):
    return

func updating_state_went_bad(response):
    print(response)
    return


func get_updated_turn_state():
    var updated_state = {
        'initial_state': self.bag.match_state.get_final_state(),
        'moves': self.bag.match_state.actions_taken,
        'final_state': self.bag.saving.get_current_state()
    }

    return updated_state

