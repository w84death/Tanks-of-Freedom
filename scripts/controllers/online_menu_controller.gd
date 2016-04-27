
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
    self.download_button = self.controls.get_node("download")
    self.download_button.connect("pressed", self, "_download_button_pressed")

    self.upload_button = self.controls.get_node("upload")
    self.upload_button.connect("pressed", self, "_upload_button_pressed")

    self.back_button = self.controls.get_node("back")
    self.back_button.connect("pressed", self, "_back_button_pressed")

    self.middle_container = self.online_menu.get_node('middle')
    self.middle_container.hide()

func _back_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.hide()
    self.bag.root.menu.online_button.grab_focus()


func _download_button_pressed():
    self.bag.root.sound_controller.play('menu')
    #if self.bag.online_maps.download_map(self.file_name.get_text()):
    #    self.bag.workshop.show_message("Success", 'Map has been downloaded.', "", "OK")
    #else:
    #    self.bag.workshop.show_message("Error", 'Could not download a map. Please check if code is correct or try again later.', "", "OK")
func _upload_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.show_maps_list_for_upload()
    #var map_data = self.bag.workshop.map.get_map_data_as_array()
    #var map_name = self.file_name.get_text()
    #if self.bag.online_maps.upload_map(map_data, map_name):
    #    self.bag.workshop.show_message("Success", 'Map has been uploaded.', "", "OK")
    #else:
    #    self.bag.workshop.show_message("Error", 'Could not upload a map. Please try again later.', "", "OK")

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
    self.controls.hide()
    self.background.hide()

func upload_custom_map(map_name):
    self.bag.map_picker.detach_panel()
    self.selected_map_name = map_name

    self.bag.confirm_popup.attach_panel(self.middle_container)
    self.bag.confirm_popup.fill_labels('Upload map', map_name, 'Upload', 'Cancel')
    self.bag.confirm_popup.connect(self, "confirm_map_upload")

func confirm_map_upload(confirmation):
    self.bag.confirm_popup.detach_panel()
    if confirmation:
        self.bag.message_popup.attach_panel(self.middle_container)
        self.bag.message_popup.fill_labels("Upload map", "Uploading! Please wait.", "")
        self.bag.message_popup.hide_button()
        self.bag.timers.set_timeout(1, self, 'map_upload_complete_show', ['Upload complete!'])
    else:
        self.middle_container.hide()
        self.controls.show()
        self.background.show()

func map_upload_complete_show(message):
    self.bag.confirm_popup.detach_panel()
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels("Upload map", message[0], "Done")
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
        self.bag.timers.set_timeout(1, self, 'do_online_register')
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