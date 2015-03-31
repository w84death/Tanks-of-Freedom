
extends EmptyControl

	# message
	hud_message = self.get_node("message")
	hud_message_box = hud_message.get_node("CenterContainer/center/box")
	hud_message_title = hud_message_box.get_node("title")
	hud_message_message = hud_message_box.get_node("message")

func _ready():
	pass


