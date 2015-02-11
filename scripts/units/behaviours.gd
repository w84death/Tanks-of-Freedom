extends "res://scripts/unit_control.gd"

const action_attack = 0
const action_move   = 1
const action_capture = 2

var ap_cost_modifier = 4
var path_size_modifier = 8
var action_type_modifiers = [3, 2, 20]
var capture_modifiers = [3,2,2]

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3

func estimate_action(action_type, path_size, ap_cost):
	var score = 100
	if action_type == ACTION_CAPTURE:
		score = 50 * capture_modifiers[type]

	score = score * action_type_modifiers[action_type]
	score = score - ap_cost_modifier * ap_cost
	score = score - path_size_modifier * path_size

	return score

func can_capture_building(building):
	return false

func can_capture():
	return false

func can_attack_unit_type(defender):
	if type == 1 && defender.type == 2:
		return false

	return true




