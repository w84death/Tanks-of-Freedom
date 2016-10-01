
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
    return

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
    return

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
    return

func show_side():
    return

func show_player_status():
    return

func show_match_status():
    return

func show_map_code():
    return

func show_forfeit_button():
    return

func show_play_button():
    return

func show_replay_button():
    return

func show_clear_button():
    return

func show_error():
    return

func show():
    self.panel.show()

func hide():
    self.panel.hide()
