extends "res://scripts/bag_aware.gd"

var popup = load("res://gui/gamepad.tscn").instance()

var close_button

func _initialize():
	self.bind()

func bind():
	self.close_button = self.popup.get_node('center/close')
	self.close_button.connect('pressed', self, '_close_button_pressed')

func _close_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.hide()

func show():
	self.bag.root.menu.add_child(popup)
	self.bag.root.menu.hide_control_nodes()
	self.bag.timers.set_timeout(0.1, self.close_button, "grab_focus")

func hide():
	self.bag.root.menu.remove_child(popup)
	self.bag.root.menu.show_control_nodes()
	if self.bag.root.menu.get_settings_visibility():
		self.bag.timers.set_timeout(0.1, self.bag.root.menu.settings_nav_pad, "grab_focus")
	else:
		self.bag.timers.set_timeout(0.1, self.bag.root.menu.campaign_button, "grab_focus")

