extends Timer

var timeout = 0
var elapsed = 0
var end_turn = false
var state = null

const INTERVAL = 0.2
const COOLDOWN_INTERVAL = 0.25

const AI_STUFF = 1
const END_TURN = 2

var root
var action_controller
var hud_controller

var is_on_cooldown = false

func _process(delta):
	if get_parent().is_paused || self.is_on_cooldown:
		return

	if root.dependency_container.abstract_map.map.panning:
		return

	timeout += delta

	if state == END_TURN:
		self.stop()
		end_turn = false
		action_controller.end_turn()
	else:
		var result = action_controller.perform_ai_stuff()
		if (result != true):
			state = END_TURN

func inject_action_controller(controller, hud):
	self.root = controller.root_node
	self.action_controller = controller
	self.hud_controller = hud

func reset():
	state = AI_STUFF
	timeout = 0
	end_turn = false

func reset_state():
	self.stop()
	self.reset()
	if action_controller != null:
		action_controller.ai.reset_calculation_state()
	action_controller = null
	hud_controller = null

