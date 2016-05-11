
var bag

var MAPS_URL = "/maps"

var ONLINE_MAP_EXTENSION = ".remote"

var last_upload_code

func _init_bag(bag):
    self.bag = bag

func can_transfer():
    if not self.bag.online_request.enabled or self.bag.online_player.player_id == null:
        return false
    return true

func upload_map(data, name):
    var message = self.bag.online_player.get_basic_auth_json()
    var serialized_json = ""

    message['data'] = {
        'tiles' : data,
        'name' : name
    }

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

    var remote_file_name = self.get_remote_file_name(code)
    if self.bag.file_handler.file_exists(remote_file_name):
        return true

    var result = self.bag.online_request.get(self.bag.online_request.api_location, self.MAPS_URL + "/" + code + ".json")
    if result['status'] != 'ok':
        return false

    var metadata = {
        'name' : result['data']['data']['name']
    }
    self.save_map(result['data']['data']['tiles'], code, metadata)

    return true

func save_map(data, code, metadata = {}):
    var remote_file_name = self.get_remote_file_name(code)
    self.bag.file_handler.write(remote_file_name, data)
    self.bag.map_list.store_remote_map(code, metadata)

func get_remote_file_name(code):
    return "user://" + code + self.ONLINE_MAP_EXTENSION
