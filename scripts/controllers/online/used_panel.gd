
const MATCH_STATE_NEW = 0
const MATCH_STATE_IN_PROGRESS = 1
const MATCH_STATE_ENDED = 2
const MATCH_STATE_FORFEIT = 3

const MATCH_SIDE_BLUE = 0
const MATCH_SIDE_RED = 1

const MATCH_PLAYER_STATE_ACTIVE = 0
const MATCH_PLAYER_STATE_INACTIVE = 1
const MATCH_PLAYER_STATE_WIN = 2
const MATCH_PLAYER_STATE_LOSS = 3
const MATCH_PLAYER_STATE_DISMISSED = 4

var bag
var panel

var match_code_label
var map_code_label
var status_label
var side_red
var side_blue
var play_button
var forfeit_button
var clear_button
var replay_button

var match_join_code
var player_side
var map_code

var match_status
var player_status

func _init_bag(bag, panel):
    self.bag = bag
    self.panel = panel

    self.bind()

func bind():
    self.match_code_label = self.panel.get_node('match_code')
    self.map_code_label = self.panel.get_node('map_code')
    self.status_label = self.panel.get_node('status')
    self.side_red = self.panel.get_node('red')
    self.side_blue = self.panel.get_node('blue')
    self.play_button = self.panel.get_node('play')
    self.forfeit_button = self.panel.get_node('forfeit')
    self.clear_button = self.panel.get_node('clear')
    self.replay_button = self.panel.get_node('replay')

    self.play_button.connect("pressed", self, "_play_button_pressed")
    self.forfeit_button.connect("pressed", self, "_forfeit_button_pressed")
    self.clear_button.connect("pressed", self, "_clear_button_pressed")
    self.replay_button.connect("pressed", self, "_replay_button_pressed")

func _play_button_pressed():
    self.bag.root.sound_controller.play('menu')

func _forfeit_button_pressed():
    self.bag.root.sound_controller.play('menu')

func _clear_button_pressed():
    self.bag.root.sound_controller.play('menu')

func _replay_button_pressed():
    self.bag.root.sound_controller.play('menu')

func bind_match_data(data):
    self.match_join_code = data['join_code']
    self.player_side = data['side']
    self.map_code = data['map_code']
    self.match_status = data['match_status']
    self.player_status = data['player_status']

    self.apply_proper_state()

func apply_proper_state():
    self.reset_layout()

    if self.match_status == self.MATCH_STATE_NEW:
        self.switch_to_new_layout()
    elif self.match_status == self.MATCH_STATE_IN_PROGRESS:
        self.switch_to_in_progress_layout()
    elif self.match_status == self.MATCH_STATE_ENDED:
        self.switch_to_ended_layout()
    elif self.match_status == self.MATCH_STATE_FORFEIT:
        self.switch_to_forfeit_layout()
    else:
        self.switch_to_error_layout()

func reset_layout():
    self.match_code_label.hide()
    self.map_code_label.hide()
    self.status_label.hide()
    self.side_red.hide()
    self.side_blue.hide()
    self.play_button.hide()
    self.forfeit_button.hide()
    self.clear_button.hide()
    self.replay_button.hide()

func switch_to_new_layout():
    self.show_side()
    self.show_match_code()
    self.show_match_status()
    self.show_map_code()
    self.show_clear_button()

func switch_to_in_progress_layout():
    self.show_side()
    self.show_match_code()
    self.show_player_status()
    self.show_map_code()
    self.show_play_button()
    self.show_forfeit_button()

func switch_to_ended_layout():
    self.show_side()
    self.show_match_code()
    self.show_player_status()
    self.show_map_code()
    self.show_clear_button()

func switch_to_forfeit_layout():
    self.show_side()
    self.show_match_code()
    self.show_match_status()
    self.show_map_code()
    self.show_clear_button()

func switch_to_error_layout():
    self.show_error()
    self.show_clear_button()

func show_match_code():
    self.match_code_label.set_text(tr('LABEL_MATCH_CODE') + self.match_join_code)
    self.match_code_label.show()

func show_side():
    if self.player_side == self.MATCH_SIDE_BLUE:
        self.side_blue.show()
    elif self.player_side == self.MATCH_SIDE_RED:
        self.side_red.show()

func show_player_status():
    var status
    if self.player_status == MATCH_PLAYER_STATE_ACTIVE:
        status = tr('LABEL_YOUR_TURN')
    elif self.player_status == MATCH_PLAYER_STATE_INACTIVE:
        status = tr('LABEL_ENEMY_TURN')
    elif self.player_status == MATCH_PLAYER_STATE_WIN:
        status = tr('LABEL_YOU_WIN')
    elif self.player_status == MATCH_PLAYER_STATE_LOSS:
        status = tr('LABEL_YOU_LOSE')

    self.status_label.set_text(status)
    self.status_label.show()

func show_match_status():
    var status
    if self.match_status == MATCH_STATE_NEW:
        status = tr('LABEL_NEW_MATCH')
    elif self.match_status == MATCH_STATE_IN_PROGRESS:
        status = tr('LABEL_MATCH_IN_PROGRESS')
    elif self.match_status == MATCH_STATE_ENDED:
        status = tr('LABEL_MATCH_ENDED')
    elif self.match_status == MATCH_STATE_FORFEIT:
        status = tr('LABEL_MATCH_FORFEIT')

    self.status_label.set_text(status)
    self.status_label.show()

func show_map_code():
    self.map_code_label.set_text(tr('LABEL_MAP_CODE') + self.map_code)
    self.map_code_label.show()

func show_forfeit_button():
    self.forfeit_button.show()

func show_play_button():
    self.play_button.show()

func show_replay_button():
    self.replay_button.show()

func show_clear_button():
    self.clear_button.show()

func show_error():
    self.map_code_label.set_text(tr('LABEL_INVALID_MATCH') + self.map_code)
    self.map_code_label.show()

func show():
    self.panel.show()

func hide():
    self.panel.hide()





func show_abandon_confirmation():
    return