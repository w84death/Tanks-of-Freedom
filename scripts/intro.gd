
extends Control

# zuo istnieje
var root
var anim
var demo_timer

func _input(event):
	if ( event.type == InputEvent.KEY and event.pressed ) or (event.type == InputEvent.MOUSE_BUTTON):
		self.demo_timer.stop()
		self.root.unlock_for_demo()
		self.root.load_menu()


func init_root(root):
	self.root = root
	
func _ready():
	anim = self.get_node("anim")
	self.demo_timer = root.get_node("DemoTimer")
	self.demo_timer.inject_root(root)
	set_process_input(true)
	pass

func _on_idle_timer_timeout():
	anim.play("idle")
	self.demo_timer.reset()
	self.demo_timer.start()
	pass # replace with function body
