extends "res://scripts/bag_aware.gd"

var popup_regular_template = preload("res://gui/popups/prompt.tscn")
var popup_mobile_template = preload("res://gui/popups/prompt_mobile.tscn")

var popup

var hud_title
var hud_message
var confirm_button
var cancel_button
var input_box

var bound_object
var bound_method

var current_container

func _initialize():
	self.select_prompt_template()
	self.bind_hud()
	self.connect_buttons()

func select_prompt_template():
	if ProjectSettings.get_setting("tof/mobile_prompt"):
		self.popup = self.popup_mobile_template.instance()
	else:
		self.popup = self.popup_regular_template.instance()

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
	self.cancel_button = self.popup.get_node("cancel")
	self.input_box = self.popup.get_node('input')

func attach_panel(container_node):
	if self.current_container != null:
		self.detach_panel()
	self.current_container = container_node
	self.current_container.add_child(self.popup)

func detach_panel():
	if self.current_container != null:
		self.current_container.remove_child(self.popup)
		self.current_container = null
	self.disconnect__s()
	self.clear_prepopulate()

func connect_buttons():
	self.confirm_button.connect("pressed", self, "_confirm_button_pressed")
	self.cancel_button.connect("pressed", self, "_cancel_button_pressed")

func disconnect__s():
	self.bound_object = null
	self.bound_method = null

func fill_labels(title, message, confirm, cancel):
	self.hud_title.set_text(title)
	self.hud_message.set_text(message)
	self.confirm_button.set_trans_key(confirm)
	self.cancel_button.set_trans_key(cancel)

func connect__s(bound_object, bound_method):
	self.bound_object = bound_object
	self.bound_method = bound_method

func call_bound_object(confirmation):
	if self.bound_object != null:
		var input_text
		if confirmation:
			input_text = self.input_box.get_text()
		else:
			input_text = ""
		self.bound_object.call(self.bound_method, confirmation, input_text)

func prepopulate(text):
	self.input_box.set_text(str(text))
func clear_prepopulate():
	self.prepopulate("")

