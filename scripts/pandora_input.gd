extends "res://scripts/bag_aware.gd"

var accumulated_time = 0

var painting = false
var erasing = false

func handle_input(event):
	self.handle_button(event)

func handle_button(event):
	if self.bag.workshop.is_working:
		if Input.is_action_pressed('gamepad_build'):
			if event.pressed:
				self.bag.root.sound_controller.play('menu')
				self.bag.workshop.paint(self.bag.workshop.selector_position)
			self.painting = event.pressed
		if Input.is_action_pressed('gamepad_end'):
			if event.pressed:
				self.bag.root.sound_controller.play('menu')
				self.bag.workshop.paint(self.bag.workshop.selector_position, 'terrain', -1)
			self.erasing = event.pressed
	else:
		if Input.is_action_pressed('gamepad_end') and event.pressed and not self.bag.root.hud_controller.hud_message_card_visible:
			self.bag.root.sound_controller.play('menu')
			self.bag.root.action_controller.end_turn()
		if Input.is_action_pressed('gamepad_build') and event.pressed:
			self.bag.root.sound_controller.play('menu')
			self.bag.root.action_controller.spawn_unit_from_active_building()
		if Input.is_action_pressed('gamepad_prev') and event.pressed:
			self.bag.root.action_controller.switch_unit(self.bag.unit_switcher.BACK)
		if Input.is_action_pressed('gamepad_next') and event.pressed:
			self.bag.root.action_controller.switch_unit(self.bag.unit_switcher.NEXT)
