var action_attack
var action_move
var action_capture
var action_spawn
var action_move_attack
var action_move_capture
var action_controller
var abstract_map

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3
const ACTION_MOVE_TO_ATTACK = 4
const ACTION_MOVE_TO_CAPTURE = 5

func _init(abstract_map_object):
	action_move = preload('res://scripts/ai/actions/types/move.gd')
	action_attack = preload('res://scripts/ai/actions/types/attack.gd')
	action_capture = preload('res://scripts/ai/actions/types/capture.gd')
	action_spawn = preload('res://scripts/ai/actions/types/spawn.gd')
	action_move_attack = preload('res://scripts/ai/actions/types/move_attack.gd')
	action_move_capture = preload('res://scripts/ai/actions/types/move_capture.gd')

	action_controller = preload('res://scripts/action_controller.gd')
	abstract_map = abstract_map_object

func create(action_type, obj, path):
	var action = null
	var set_abstract_map = false

	if action_type == self.ACTION_MOVE:
		action = action_move.new(obj, path)
	elif action_type == self.ACTION_CAPTURE:
		action = action_capture.new(obj, path)
	elif action_type == self.ACTION_SPAWN:
		action = action_spawn.new(obj, path)
	elif action_type == self.ACTION_MOVE_TO_ATTACK:
		action = action_move_attack.new(obj, path)
	elif action_type == self.ACTION_MOVE_TO_CAPTURE:
		action = action_move_capture.new(obj, path)
	else:
		action = action_attack.new(obj, path)

	if set_abstract_map:
		action.set_abstract_map(abstract_map)
	action.set_action_controller(action_controller)

	return action
