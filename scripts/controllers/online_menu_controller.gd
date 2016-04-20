
var bag

var online_menu = preload("res://gui/online_menu.tscn").instance()

var back_button

func _init_bag(bag):
    self.bag = bag
    self.bind()
    self.attach_campaign_menu()

func bind():
    self.back_button = self.online_menu.get_node("controls/back")
    self.back_button.connect("pressed", self, "_back_button_pressed")

func _back_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.hide()
    self.bag.root.menu.online_button.grab_focus()

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
