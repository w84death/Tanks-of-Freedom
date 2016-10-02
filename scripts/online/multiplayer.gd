
const MATCHES_LIST_URL = "/matches/my"
const MATCH_CREATE_URL = "/matches"
const MATCH_DETAILS_URL = "/match/"
const MATCH_JOIN_URL = "/match/join/"

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
