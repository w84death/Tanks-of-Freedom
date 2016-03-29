
var bag

var player_id = null
var player_pin = null

var enabled = false
var api_location = null

var REGISTER_URL = "/players"

func _init_bag(bag):
    self.bag = bag
    self.enabled = Globals.get('tof/online')
    self.api_location = Globals.get('tof/api_location')

    self.player_id = self.bag.root.settings['online_player_id']
    self.player_pin = self.bag.root.settings['online_player_pin']

func request_player_id():
    if not self.enabled or self.player_id != null:
        return

    var response = self.bag.online_request.post(self.api_location, self.REGISTER_URL)

    if response['status'] != 'ok':
        return

    self.player_id = response['data']['id']
    self.player_pin = response['data']['pin']
    self.bag.root.settings['online_player_id'] = self.player_id
    self.bag.root.settings['online_player_pin'] = self.player_pin
    self.bag.root.write_settings_to_file()
    self.bag.controllers.workshop_gui_controller.file_panel.refresh_player_id()


func get_player_id():
    if not self.enabled:
        return null

    return self.player_id