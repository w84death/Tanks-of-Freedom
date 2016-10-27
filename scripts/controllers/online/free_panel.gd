
var bag
var panel

var create_button
var join_button

var online_menu_controller
var middle_container
var controls
var background

var selected_match
var selected_map
var selected_side

func _init_bag(bag, panel):
    self.bag = bag
    self.panel = panel

    self.bind()

func bind():
    self.create_button = self.panel.get_node('create')
    self.join_button = self.panel.get_node('join')

    self.create_button.connect("pressed", self, "_create_button_pressed")
    self.join_button.connect("pressed", self, "_join_button_pressed")

    self.online_menu_controller = self.bag.controllers.online_menu_controller
    self.controls = self.online_menu_controller.controls
    self.middle_container = self.online_menu_controller.middle_container
    self.background = self.online_menu_controller.background

func _create_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.begin_create_match_process()

func _join_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.show_join_code_prompt()

func begin_create_match_process():
    self.ask_if_really_want_to_create()

func ask_if_really_want_to_create():
    self.middle_container.show()
    self.controls.hide()
    self.background.hide()
    self.bag.confirm_popup.attach_panel(self.middle_container)
    self.bag.confirm_popup.fill_labels(tr('LABEL_CREATE_MATCH'), tr('MSG_CONFIRM_CREATE'), tr('LABEL_PROCEED'), tr('LABEL_CANCEL'))
    self.bag.confirm_popup.connect(self, "confirm_start_creation")
    self.bag.confirm_popup.confirm_button.grab_focus()

func confirm_start_creation(confirmation):
    self.bag.confirm_popup.detach_panel()
    if confirmation:
        self.show_map_picker()
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()
        self.create_button.grab_focus()

func show_map_picker():
    self.bag.map_picker.attach_panel(self.middle_container)
    self.bag.map_picker.connect(self, "select_side")
    self.bag.map_picker.lock_delete_mode_button()
    self.bag.map_picker.switch_to_remote_list()
    self.bag.map_picker.disable_list_switch()
    if self.bag.map_picker.blocks_cache.size() > 0:
        self.bag.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()

func select_side(map_code, is_remote = true):
    self.bag.map_picker.detach_panel()
    self.selected_map = map_code
    self.bag.confirm_popup.attach_panel(self.middle_container)
    self.bag.confirm_popup.fill_labels(tr('LABEL_PICK_SIDE'), tr('MSG_PICK_SIDE'), tr('LABEL_BLUE'), tr('LABEL_RED'))
    self.bag.confirm_popup.connect(self, "ask_if_selected_data_is_ok")
    self.bag.confirm_popup.confirm_button.grab_focus()

func ask_if_selected_data_is_ok(selected_side):
    var side_name
    var message

    if selected_side:
        self.selected_side = 0
        side_name = tr('LABEL_BLUE')
    else:
        self.selected_side = 1
        side_name = tr('LABEL_RED')

    message = tr('MSG_SELECTED_MAP') + self.selected_map + '. ' + tr('MSG_SELECTED_SIDE') + side_name + '. ' + tr('MSG_READY_TO_CREATE')

    self.bag.confirm_popup.fill_labels(tr('LABEL_CREATE_MATCH'), message, tr('LABEL_PROCEED'), tr('LABEL_CANCEL'))
    self.bag.confirm_popup.connect(self, "confirm_commit_creation")
    self.bag.confirm_popup.confirm_button.grab_focus()

func confirm_commit_creation(confirmation):
    self.bag.confirm_popup.detach_panel()
    if confirmation:
        self.perform_match_creation()
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()
        self.create_button.grab_focus()

func perform_match_creation():
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_CREATE_MATCH'), tr('MSG_CREATING_MATCH_WAIT'), "")
    self.bag.message_popup.hide_button()
    self.bag.online_multiplayer.create_new_match(self.selected_map, self.selected_side, self, 'operation_completed', 'operation_failed')

func operation_completed(response={}):
    self.bag.message_popup.detach_panel()
    self.online_menu_controller.multiplayer.refresh_matches_list()

func operation_failed(response={}):
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_FAILURE'), tr('MSG_OPERATION_FAILED'), tr('LABEL_DONE'))
    self.bag.message_popup.connect(self, "operation_completed")
    self.bag.message_popup.confirm_button.grab_focus()


func show_join_code_prompt():
    self.controls.hide()
    self.background.hide()
    self.bag.prompt_popup.attach_panel(self.middle_container)
    self.bag.prompt_popup.fill_labels(tr('LABEL_JOIN_MATCH'), tr('MSG_INPUT_MATCH_CODE'), tr('LABEL_JOIN'), tr('LABEL_CANCEL'))
    self.bag.prompt_popup.connect(self, "confirm_join_match")
    self.bag.prompt_popup.clear_prepopulate()
    self.middle_container.show()
    self.bag.prompt_popup.input_box.grab_focus()

func confirm_join_match(confirmation, code):
    self.bag.prompt_popup.detach_panel()
    if confirmation:
        if self.online_menu_controller.multiplayer.has_match(code):
            self.already_in_match()
            return

        self.perform_get_match_details(code)
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()
        self.join_button.grab_focus()

func already_in_match():
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_FAILURE'), tr('MSG_ALREADY_IN_MATCH'), tr('LABEL_DONE'))
    self.bag.message_popup.connect(self, "operation_completed")
    self.bag.message_popup.confirm_button.grab_focus()

func perform_get_match_details(code):
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_JOIN_MATCH'), tr('MSG_FETCHING_MATCH_DETAILS'), "")
    self.bag.message_popup.hide_button()
    self.bag.online_multiplayer.fetch_match_details(code, self, 'show_match_details_confirmation', 'operation_failed')

func show_match_details_confirmation(response):
    self.selected_match = response['data']['join_code']
    self.selected_map = response['data']['map_code']
    self.selected_side = response['data']['available_side']

    var side_name = self.get_side_name(self.selected_side)

    var message = tr('MSG_SELECTED_MAP') + self.selected_map + '. ' + tr('MAG_AVAILABLE_SIDE') + side_name + '. ' + tr('MAG_PROCEED_JOIN')

    self.bag.message_popup.detach_panel()
    self.bag.confirm_popup.attach_panel(self.middle_container)
    self.bag.confirm_popup.fill_labels(tr('LABEL_JOIN_MATCH'), message, tr('LABEL_PROCEED'), tr('LABEL_CANCEL'))
    self.bag.confirm_popup.connect(self, "confirm_join_match_final")
    self.bag.confirm_popup.confirm_button.grab_focus()

func confirm_join_match_final(confirmation):
    self.bag.confirm_popup.detach_panel()
    if confirmation:
        self.perform_join_match()
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()
        self.join_button.grab_focus()

func perform_join_match():
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_JOIN_MATCH'), tr('MSG_JOINING_MATCH_WAIT'), "")
    self.bag.message_popup.hide_button()
    self.bag.online_multiplayer.join_match(self.selected_match, self, 'operation_completed', 'operation_failed')


func show():
    self.panel.show()
    self.create_button.get_node('Label').set_text(tr('LABEL_CREATE'))
    self.join_button.get_node('Label').set_text(tr('LABEL_JOIN'))
    self.panel.get_node('Label').set_text(tr('LABEL_NEW_MATCH'))

    if self.bag.map_list.remote_maps.size() == 0:
        self.create_button.set_disabled(true)
        self.create_button.get_node('Label').hide()
    else:
        self.create_button.set_disabled(false)
        self.create_button.get_node('Label').show()

func hide():
    self.panel.hide()

func get_side_name(side):
    if side == 0:
        return tr('LABEL_BLUE')
    elif side == 1:
        return tr('LABEL_RED')