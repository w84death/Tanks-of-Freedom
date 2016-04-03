
var bag

var MAPS_URL = "/maps"

var ONLINE_MAP_EXTENSION = ".remote"

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

    self.save_map(data, result['data']['code'])

    return true

func download_map(code):
    return true

func save_map(data, code):
    var remote_file_name = "user://" + code + self.ONLINE_MAP_EXTENSION
    self.bag.file_handler.write(remote_file_name, data)
