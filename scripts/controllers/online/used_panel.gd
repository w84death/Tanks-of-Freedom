
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

var online_menu_controller
var middle_container
var controls
var background

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

var match_state_loading_follow_up = ""

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

	self.online_menu_controller = self.bag.controllers.online_menu_controller
	self.controls = self.online_menu_controller.controls
	self.middle_container = self.online_menu_controller.middle_container
	self.background = self.online_menu_controller.background

func _play_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.start_loading_match()

func _forfeit_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.ask_if_really_want_to_abandon()

func _clear_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.clear_without_asking()

func _replay_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.start_loading_replay()

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

	if self.player_status == MATCH_PLAYER_STATE_LOSS:
		self.show_replay_button()

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






func ask_if_really_want_to_abandon():
	self.middle_container.show()
	self.controls.hide()
	self.background.hide()
	self.bag.confirm_popup.attach_panel(self.middle_container)
	self.bag.confirm_popup.fill_labels(tr('LABEL_ABANDON_MATCH'), tr('MAG_ABANDON_MATCH'), tr('LABEL_PROCEED'), tr('LABEL_CANCEL'))
	self.bag.confirm_popup.connect(self, "confirm_abandon_match")
	self.bag.confirm_popup.confirm_button.grab_focus()

func clear_without_asking():
	self.middle_container.show()
	self.controls.hide()
	self.background.hide()
	self.confirm_abandon_match(true)

func confirm_abandon_match(confirmation):
	self.bag.confirm_popup.detach_panel()
	if confirmation:
		self.perform_abandon_match()
	else:
		self.middle_container.hide()
		self.controls.show()
		self.background.show()
		self.forfeit_button.grab_focus()

func perform_abandon_match():
	self.bag.message_popup.attach_panel(self.middle_container)
	self.bag.message_popup.fill_labels(tr('LABEL_CLEAR_SLOT'), tr('MSG_CLEARING_SLOT_WAIT'), "")
	self.bag.message_popup.hide_button()

	if self.is_already_loaded():
		self.bag.match_state.reset()
		self.bag.root.unload_map()

	self.bag.online_multiplayer.abandon_match(self.match_join_code, self, 'operation_completed', 'operation_failed')

func operation_completed(response={}):
	self.bag.message_popup.detach_panel()
	self.online_menu_controller.multiplayer.refresh_matches_list()

func operation_failed(response={}):
	self.bag.message_popup.attach_panel(self.middle_container)
	self.bag.message_popup.fill_labels(tr('LABEL_FAILURE'), tr('MSG_OPERATION_FAILED'), tr('LABEL_DONE'))
	self.bag.message_popup.connect(self, "operation_completed")
	self.bag.message_popup.confirm_button.grab_focus()


func is_already_loaded():
	if not self.bag.match_state.current_loaded_multiplayer_state.has('join_code'):
		return false

	if self.bag.match_state.current_loaded_multiplayer_state['join_code'] == self.match_join_code:
		return true

	return false


func start_loading_match():
	if self.is_already_loaded():
		self.bag.controllers.online_menu_controller.hide()
		self.bag.root.hide_menu()
		return

	self.prepare_match_data_and_perform_action("continue_loading_match")

func continue_loading_match():
	if self.bag.match_state.is_current_multiplayer_game_ended():
		self.online_menu_controller.multiplayer.refresh_matches_list()
		return

	if self.bag.match_state.is_replay_available():
		self.ask_load_replay_or_turn()
	else:
		self.bag.controllers.online_menu_controller.hide()
		self.bag.online_multiplayer.load_game_from_state()
		self.bag.root.hide_menu()

func ask_load_replay_or_turn():
	self.middle_container.show()
	self.controls.hide()
	self.background.hide()
	self.bag.confirm_popup.attach_panel(self.middle_container)
	self.bag.confirm_popup.fill_labels(tr('LABEL_SHOW_REPLAY'), tr('MSG_SHOW_REPLAY'), tr('LABEL_REPLAY'), tr('LABEL_SKIP'))
	self.bag.confirm_popup.connect(self, "confirm_load_replay_or_turn")
	self.bag.confirm_popup.confirm_button.grab_focus()

func confirm_load_replay_or_turn(confirmation):
	self.bag.confirm_popup.detach_panel()
	self.middle_container.hide()
	self.controls.show()
	self.background.show()

	self.bag.controllers.online_menu_controller.hide()

	if confirmation:
		self.bag.online_multiplayer.load_replay_from_state()
	else:
		self.bag.online_multiplayer.load_game_from_state()
	self.bag.root.hide_menu()


func start_loading_replay():
	if self.is_already_loaded():
		self.bag.controllers.online_menu_controller.hide()
		self.bag.root.hide_menu()
		return

	self.prepare_match_data_and_perform_action("continue_loading_replay")

func continue_loading_replay():
	if self.bag.match_state.is_end_replay_available():
		self.bag.controllers.online_menu_controller.hide()
		self.bag.online_multiplayer.load_replay_from_state()
		self.bag.root.hide_menu()



func prepare_match_data_and_perform_action(follow_up_method):
	self.match_state_loading_follow_up = follow_up_method
	self.middle_container.show()
	self.controls.hide()
	self.background.hide()
	self.load_match_state()

func finished_preparing_match_data():
	self.middle_container.hide()
	self.controls.show()
	self.background.show()
	self.call(self.match_state_loading_follow_up)

func load_match_state():
	self.bag.message_popup.attach_panel(self.middle_container)
	self.bag.message_popup.fill_labels(tr('LABEL_LOADING_MATCH'), tr('MSG_LOADING_MATCH_WAIT'), "")
	self.bag.message_popup.hide_button()
	self.bag.online_multiplayer.load_match_state(self.match_join_code, self, "finished_loading_match_state", 'operation_failed')

func finished_loading_match_state(response):
	self.bag.message_popup.detach_panel()
	self.bag.match_state.current_loaded_multiplayer_state = response['data']
	self.verify_map_availability()

func verify_map_availability():
	var map_code = self.bag.match_state.current_loaded_multiplayer_state['map_code']
	if self.bag.map_list.has_remote_map(map_code):
		self.finished_preparing_match_data()
	else:
		self.download_remote_map(map_code)

func download_remote_map(code):
	self.bag.message_popup.attach_panel(self.middle_container)
	self.bag.message_popup.fill_labels(tr('LABEL_DOWNLOAD_MAP'), tr('TIP_DOWNLOADING_WAIT'), "")
	self.bag.message_popup.hide_button()
	self.bag.timers.set_timeout(0.5, self, 'perform_map_download', [code])

func perform_map_download(code):
	if self.bag.online_maps.download_map(code[0]):
		self.bag.message_popup.detach_panel()
		self.finished_preparing_match_data()
	else:
		self.operation_failed({})

