extends Timer

var timeout = 0
var elapsed = 0
var end_turn = false

const INTERVAL = 0.4
const END_TURN_INTERVAL = 2

var action_controller

func _process(delta):
	timeout += delta
	var interval = INTERVAL
	if (end_turn):
		interval = END_TURN_INTERVAL

	if timeout > interval:
		if end_turn:
			action_controller.end_turn()
			end_turn = false
			self.stop()

		var result = action_controller.perform_ai_stuff()
		if (result == true):
			timeout = 0
		else:
			end_turn = true

func inject_action_controller(controller):
	action_controller = controller