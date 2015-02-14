extends Timer

var timeout = 0
var elapsed = 0
var end_turn = false
var state = null

const INTERVAL = 0.4
const END_TURN_INTERVAL = 1.5
const HIDE_HUD_INTERVAL = 1.5

const HIDE_HUD = 0;
const AI_STUFF = 1;
const END_TURN = 2;


var action_controller
var hud_controller

func _process(delta):
	timeout += delta

	if timeout > self.get_interval():
		if state == END_TURN:
			action_controller.end_turn()
			end_turn = false
			self.stop()
		elif state == HIDE_HUD:
			state = AI_STUFF
		else:
			var result = action_controller.perform_ai_stuff()
			if (result != true):
				state = END_TURN
		timeout = 0

func get_interval():
	if state == HIDE_HUD:
		return HIDE_HUD_INTERVAL
	elif state == END_TURN:
		return END_TURN_INTERVAL
	else:
		return INTERVAL

func reset():
	state = HIDE_HUD
	timeout = 0
	end_turn = false

func inject_action_controller(controller, hud):
	action_controller = controller
	hud_controller = hud