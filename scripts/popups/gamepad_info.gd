
var bag

var popup = preload("res://gui/gamepad.tscn").instance()

var close_button

func _init_bag(bag):
    self.bag = bag
    self.bind()

func bind():
    self.close_button = self.popup.get_node('close')
    self.close_button.connect('pressed', self, '_close_button_pressed')

func _close_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.hide()

func show():
    self.bag.root.menu.add_child(popup)
    self.close_button.grab_focus()
    self.bag.root.menu.hide_control_nodes()

func hide():
    self.bag.root.menu.remove_child(popup)
    self.bag.root.menu.show_control_nodes()
