
extends Control

var line
var hud_title
var hud_message
var hud_button_close
var active = false

func show_message(title,message):
	self.active = true
	hud_title.set_text(title)
	hud_message.set_text(message)
	self.raise()
	return

func close_message():
	self.active = false
	#self.hide()

func is_visible():
	return self.active

func _ready():
	hud_title = self.get_node("title")
	hud_message = self.get_node("message")
	hud_button_close = self.get_node("button")
	hud_button_close.connect("pressed",self,"close_message")
	pass


