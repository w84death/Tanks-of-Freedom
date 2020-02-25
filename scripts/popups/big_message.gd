extends "res://scripts/bag_aware.gd"

var popup = load("res://gui/popups/big_message.tscn").instance()

var hud_title
var hud_message
var confirm_button


var bound_object
var bound_method

var current_container

func _initialize():
	self.bind_hud()
	self.connect_buttons()

func _confirm_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.call_bound_object()

func bind_hud():
	self.hud_title = self.popup.get_node("controls/title")
	self.hud_message = self.popup.get_node("controls/message")
	self.confirm_button = self.popup.get_node("controls/buttons/back")


func attach_panel(container_node):
	if self.current_container != null:
		self.detach_panel()
	self.current_container = container_node
	self.current_container.add_child(self.popup)

func detach_panel():
	if self.current_container != null:
		self.current_container.remove_child(self.popup)
		self.current_container = null
	self.disconnectALT()
	self.show_button()

func connect_buttons():
	self.confirm_button.connect("pressed", self, "_confirm_button_pressed")

func disconnectALT():
	self.bound_object = null
	self.bound_method = null

func fill_labels(title, messages, confirm):
	var combined_message = ""

	for message in messages:
		combined_message = combined_message + message + "\n\n";

	self.hud_message.set_text(combined_message)

	self.hud_title.set_text(title)

func connectALT(bound_object, bound_method):
	self.bound_object = bound_object
	self.bound_method = bound_method

func call_bound_object():
	if self.bound_object != null:
		self.bound_object.call(self.bound_method)

func show_button():
	self.confirm_button.show()
func hide_button():
	self.confirm_button.hide()

