
extends Control

var line
var hud_title
var hud_message
var hud_button_close

func show_message(title,message):
	hud_title.set_text(title)
	hud_message.clear()
	for line in message:
		hud_message.add_text(line)
		hud_message.newline()
		hud_message.newline()
	self.show()
	return

func close_message():
	self.hide()

func _ready():
	hud_title = self.get_node("center/center/box/title")
	hud_message = self.get_node("center/center/box/message")
	hud_button_close = self.get_node("center/center/box/close")
	hud_button_close.connect("pressed",self,"close_message")
	pass


