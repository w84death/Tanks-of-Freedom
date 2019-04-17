
extends Control

# zuo istnieje
var root
var anim
var demo_timer
var audio

func _input(event):
	if ( event is InputEventKey and event.pressed ) or (event is InputEventMouseButton and event.pressed) or (event is InputEventJoypadButton and event.pressed):
		self.root.bag.demo_mode.demo_timer.stop()
		self.root.unlock_for_demo()
		self.root.bag.timers.set_timeout(0.1, self.root, "load_menu")

		if event is InputEventJoypadButton:
			self.root.bag.gamepad.mark_gamepad(event)

func init_root(root):
	self.root = root

func _ready():
	anim = self.get_node("anim")
	audio = self.get_node('audio')
	if self.root != null && self.root.settings['music_enabled']:
		audio.play()
	set_process_input(true)
	pass

func _on_idle_timer_timeout():
	anim.play("idle")
	self.root.bag.demo_mode.start_demo_mode()
	pass # replace with function body

