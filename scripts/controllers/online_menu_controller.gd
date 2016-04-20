
var bag

var online_menu = preload("res://gui/online_menu.tscn").instance()

var back_button
var download_button
var upload_button

func _init_bag(bag):
    self.bag = bag
    self.bind()
    self.attach_campaign_menu()

func bind():
    self.download_button = self.online_menu.get_node("controls/upload")
    self.download_button.connect("pressed", self, "_download_button_pressed")

    self.upload_button = self.online_menu.get_node("controls/download")
    self.upload_button.connect("pressed", self, "_upload_button_pressed")

    self.back_button = self.online_menu.get_node("controls/back")
    self.back_button.connect("pressed", self, "_back_button_pressed")

func _back_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.hide()
    self.bag.root.menu.online_button.grab_focus()


func _download_button_pressed():
    self.root.sound_controller.play('menu')
    #if self.bag.online_maps.download_map(self.file_name.get_text()):
    #    self.bag.workshop.show_message("Success", 'Map has been downloaded.', "", "OK")
    #else:
    #    self.bag.workshop.show_message("Error", 'Could not download a map. Please check if code is correct or try again later.', "", "OK")
func _upload_button_pressed():
    self.root.sound_controller.play('menu')
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

func hide():
    self.bag.root.menu.refresh_buttons_labels()
    self.online_menu.hide()
    self.bag.controllers.menu_controller.show_control_nodes()
    self.bag.root.write_settings_to_file()
