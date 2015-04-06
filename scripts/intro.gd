
extends EmptyControl

# zuo istnieje
var root

func _input(event):
	if event.type == InputEvent.KEY and event.pressed:
		self.root.load_menu()

func init_root(root):
	self.root = root
	
func _ready():
	set_process_input(true)
	pass


