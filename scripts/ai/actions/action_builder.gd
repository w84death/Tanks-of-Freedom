extends "res://scripts/bag_aware.gd"

var action_attack
var action_move
var action_capture
var action_spawn
var action_move_attack
var action_move_capture

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3
const ACTION_MOVE_TO_ATTACK = 4
const ACTION_MOVE_TO_CAPTURE = 5

func _initialize():
	action_move = load('res://scripts/ai/actions/types/move.gd')
	action_attack = load('res://scripts/ai/actions/types/attack.gd')
	action_capture = load('res://scripts/ai/actions/types/capture.gd')
	action_spawn = load('res://scripts/ai/actions/types/spawn.gd')
	action_move_attack = load('res://scripts/ai/actions/types/move_attack.gd')
	action_move_capture = load('res://scripts/ai/actions/types/move_capture.gd')

func create(action_type, obj, path):
	var action = null

	if action_type == self.ACTION_MOVE:
		action = action_move.new(bag, obj, path)
	elif action_type == self.ACTION_CAPTURE:
		action = action_capture.new(bag, obj, path)
	elif action_type == self.ACTION_SPAWN:
		action = action_spawn.new(bag, obj, path)
	elif action_type == self.ACTION_MOVE_TO_ATTACK:
		action = action_move_attack.new(bag, obj, path)
	elif action_type == self.ACTION_MOVE_TO_CAPTURE:
		action = action_move_capture.new(bag, obj, path)
	else:
		action = action_attack.new(bag, obj, path)

	return action
