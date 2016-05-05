
var bag

var online_menu = preload("res://gui/online_menu.tscn").instance()
var controls
var background
var middle_container

var back_button
var download_button
var upload_button

var selected_map_name

var registration_successfull = false

func _init_bag(bag):
    self.bag = bag
    self.bind()
    self.attach_campaign_menu()

func bind():
    self.controls = self.online_menu.get_node("controls")
    self.background = self.online_menu.get_node("background")
    self.download_button = self.controls.get_node("horizontal/download")
    self.download_button.connect("pressed", self, "_download_button_pressed")

    self.upload_button = self.controls.get_node("horizontal/upload")
    self.upload_button.connect("pressed", self, "_upload_button_pressed")

    self.back_button = self.controls.get_node("horizontal/back")
    self.back_button.connect("pressed", self, "_back_button_pressed")

    self.middle_container = self.online_menu.get_node('middle')
    self.middle_container.hide()

func _back_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.hide()
    self.bag.root.menu.online_button.grab_focus()


func _download_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.show_map_download_code_prompt()
func _upload_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.show_maps_list_for_upload()

func attach_campaign_menu():
    self.bag.controllers.menu_controller.add_child(self.online_menu)
    self.online_menu.hide()

func show():
    self.online_menu.show()
    if self.bag.root.settings['online_player_id'] == null:
        self.show_register_confirmation()

func hide():
    self.bag.root.menu.refresh_buttons_labels()
    self.online_menu.hide()
    self.bag.controllers.menu_controller.show_control_nodes()
    self.bag.root.write_settings_to_file()

func show_maps_list_for_upload():
    self.middle_container.show()
    self.bag.map_picker.attach_panel(self.middle_container)
    self.bag.map_picker.connect(self, "upload_custom_map")
    self.bag.map_picker.lock_delete_mode_button()
    self.bag.map_picker.switch_to_local_list()
    self.bag.map_picker.disable_list_switch()
    self.controls.hide()
    self.background.hide()

func upload_custom_map(map_name, is_remote = false):
    self.bag.map_picker.detach_panel()
    self.selected_map_name = map_name
    var message = "Map to upload: " + map_name + ". Proceed?"

    self.bag.confirm_popup.attach_panel(self.middle_container)
    self.bag.confirm_popup.fill_labels('Upload map', message, 'Upload', 'Cancel')
    self.bag.confirm_popup.connect(self, "confirm_map_upload")

func confirm_map_upload(confirmation):
    self.bag.confirm_popup.detach_panel()
    if confirmation:
        self.bag.message_popup.attach_panel(self.middle_container)
        self.bag.message_popup.fill_labels("Upload map", "Uploading! Please wait.", "")
        self.bag.message_popup.hide_button()
        self.bag.timers.set_timeout(0.5, self, 'execute_map_upload')
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()

func execute_map_upload():
    var map_data = self.bag.map_list.get_local_map_data(self.selected_map_name)
    var result = self.bag.online_maps.upload_map(map_data, self.selected_map_name)
    var message

    if result:
        message = "Upload successful! New map code: " + self.bag.online_maps.last_upload_code
    else:
        message = "Upload failed. Please try again later."
    self.map_upload_complete_show(message)

func map_upload_complete_show(message):
    self.bag.confirm_popup.detach_panel()
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels("Upload map", message, "Done")
    self.bag.message_popup.connect(self, "map_upload_complete_hide")

func map_upload_complete_hide():
    self.bag.confirm_popup.detach_panel()
    self.middle_container.hide()
    self.controls.show()
    self.background.show()

func show_register_confirmation():
    self.controls.hide()
    self.background.hide()
    self.bag.confirm_popup.attach_panel(self.middle_container)
    self.bag.confirm_popup.fill_labels('Welcome to ToF Online!', 'Before you can start using online options, we need to register your device with our online system.', 'Register', 'Maybe later')
    self.bag.confirm_popup.connect(self, "register_confirmation")
    self.middle_container.show()

func register_confirmation(confirmation):
    self.bag.confirm_popup.detach_panel()
    if confirmation:
        self.bag.message_popup.attach_panel(self.middle_container)
        self.bag.message_popup.fill_labels("Register Player", "Requesting Player ID! Please wait.", "")
        self.bag.message_popup.hide_button()
        self.bag.timers.set_timeout(0.5, self, 'do_online_register')
    else:
        self.hide()
        self.bag.root.menu.online_button.grab_focus()
        self.controls.show()
        self.background.show()
        self.middle_container.hide()


func do_online_register():
    self.bag.online_player.request_player_id()
    self.bag.message_popup.attach_panel(self.middle_container)
    if self.bag.root.settings['online_player_id'] == null:
        self.bag.message_popup.fill_labels("Register Player", "Requesting Player ID failed. Please try again later.", "Done")
        self.registration_successfull = false
    else:
        self.bag.message_popup.fill_labels("Register Player", "Requesting Player ID successful. Welcome to ToF Online!", "Done")
        self.registration_successfull = true
    self.bag.message_popup.connect(self, "hide_register_confirmation")

func hide_register_confirmation():
    self.bag.message_popup.detach_panel()
    if not self.registration_successfull:
        self.hide()
        self.bag.root.menu.online_button.grab_focus()
    self.controls.show()
    self.background.show()
    self.middle_container.hide()

func show_map_download_code_prompt():
    self.controls.hide()
    self.background.hide()
    self.bag.prompt_popup.attach_panel(self.middle_container)
    self.bag.prompt_popup.fill_labels('Download map', 'Please input map code', 'Download', 'Cancel')
    self.bag.prompt_popup.connect(self, "confirm_map_download")
    self.bag.prompt_popup.clear_prepopulate()
    self.middle_container.show()
    self.bag.prompt_popup.input_box.grab_focus()

func confirm_map_download(confirmation, code):
    self.bag.prompt_popup.detach_panel()
    if confirmation:
        self.bag.message_popup.attach_panel(self.middle_container)
        self.bag.message_popup.fill_labels("Download map", "Downloading map! Please wait.", "")
        self.bag.message_popup.hide_button()
        self.bag.timers.set_timeout(0.5, self, 'perform_map_download', [code])
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()

func perform_map_download(code):
    if self.bag.online_maps.download_map(code[0]):
        self.show_map_download_done_message("Map has been downloaded.")
    else:
        self.show_map_download_done_message("Could not download a map. Please check if code is correct and try again.")

func show_map_download_done_message(message):
    self.bag.message_popup.detach_panel()
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels("Download map", message, "Done")
    self.bag.message_popup.connect(self, "hide_map_download_done_message")

func hide_map_download_done_message():
    self.bag.message_popup.detach_panel()
    self.controls.show()
    self.background.show()
    self.middle_container.hide()
