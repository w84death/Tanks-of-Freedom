
extends EmptyControl

var message
var title

func _ready():
	title = get_node('title')
	message = get_node('message')
	title.set_text('Bunker')
	message.add_text('This is your main headquater. Enemy will try to capture this building!')
	pass


