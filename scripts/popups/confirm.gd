extends "res://scripts/bag_aware.gd"

var popup = preload("res://gui/popups/confirm.tscn").instance()

var hud_title
var hud_message
var confirm_button
var confirm_button_label
var cancel_button
var cancel_button_label

var bound_object
var bound_method

var current_container

func _initialize():
	self.bind_hud()
	self.connect_buttons()

func _confirm_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.call_bound_object(true)

func _cancel_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.call_bound_object(false)

func bind_hud():
	self.hud_title = self.popup.get_node("title")
	self.hud_message = self.popup.get_node("message")
	self.confirm_button = self.popup.get_node("confirm")
	self.confirm_button_label = self.confirm_button.get_node("Label")
	self.cancel_button = self.popup.get_node("cancel")
	self.cancel_button_label = self.cancel_button.get_node("Label")

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

func connect_buttons():
	self.confirm_button.connect("pressed", self, "_confirm_button_pressed")
	self.cancel_button.connect("pressed", self, "_cancel_button_pressed")

func disconnectALT():
	self.bound_object = null
	self.bound_method = null

func fill_labels(title, message, confirm, cancel):
	self.hud_title.set_text(title)
	self.hud_message.set_text(message)
	self.confirm_button_label.set_text(confirm)
	self.cancel_button_label.set_text(cancel)

func connectALT(bound_object, bound_method):
	self.bound_object = bound_object
	self.bound_method = bound_method

func call_bound_object(confirmation):
	if self.bound_object != null:
		self.bound_object.call(self.bound_method, confirmation)
