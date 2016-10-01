
var bag
var panel

var create_button
var join_button

var online_menu_controller
var middle_container
var controls
var background

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
    self.bag.confirm_popup.fill_labels(tr('LABEL_PICK_SIDE'), tr('MSG_PICK_SIDE'), tr('LABEL_BLUE_TEAM'), tr('LABEL_RED_TEAM'))
    self.bag.confirm_popup.connect(self, "ask_if_selected_data_is_ok")
    self.bag.confirm_popup.confirm_button.grab_focus()

func ask_if_selected_data_is_ok(selected_side):
    var side_name
    var message

    if selected_side:
        self.selected_side = 0
        side_name = tr('LABEL_BLUE_TEAM')
    else:
        self.selected_side = 1
        side_name = tr('LABEL_RED_TEAM')

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
    self.bag.online_multiplayer.create_new_match(self.selected_map, self.selected_side, self, 'match_creation_complete', 'operation_failed')

func match_creation_complete(response={}):
    self.bag.message_popup.detach_panel()
    self.online_menu_controller.multiplayer.refresh_matches_list()

func operation_failed(response={}):
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_FAILURE'), tr('MSG_OPERATION_FAILED'), tr('LABEL_DONE'))
    self.bag.message_popup.connect(self, "match_creation_complete")
    self.bag.message_popup.confirm_button.grab_focus()

func show():
    self.panel.show()

func hide():
    self.panel.hide()
