
extends Control

# zuo istnieje
var root
var anim
var demo_timer
var audio

func _input(event):
    if ( event.type == InputEvent.KEY and event.pressed ) or (event.type == InputEvent.MOUSE_BUTTON) or (event.type == InputEvent.JOYSTICK_BUTTON):
        self.root.bag.demo_mode.demo_timer.stop()
        self.root.unlock_for_demo()
        self.root.load_menu()

        if event.type == InputEvent.JOYSTICK_BUTTON:
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
