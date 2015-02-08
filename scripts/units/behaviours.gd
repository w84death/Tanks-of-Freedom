extends "res://scripts/unit_control.gd"

const action_attack = 0
const action_move   = 1
const action_capture = 2

var ap_cost_modifier = 2
var can_be_finished_modifier = 20
var path_size_modifier = 5
var action_type_modifiers = [3, 2, 5]

func estimate_action(action_type, can_be_finished, destination, path_size, ap_cost):
	var score = 100
	if (can_be_finished):
		score = score + can_be_finished_modifier

	score = score * action_type_modifiers[action_type]
	score = score - ap_cost_modifier * ap_cost
	score = score - path_size_modifier * path_size

	return score




