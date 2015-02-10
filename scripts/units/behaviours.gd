extends "res://scripts/unit_control.gd"

const action_attack = 0
const action_move   = 1
const action_capture = 2

var ap_cost_modifier = 4
var path_size_modifier = 8
var action_type_modifiers = [3, 2, 20]

func estimate_action(action_type, path_size, ap_cost):
	var score = 100
	score = score * action_type_modifiers[action_type]
	score = score - ap_cost_modifier * ap_cost
	score = score - path_size_modifier * path_size

	return score

func can_capture_building(building):
	return false

func can_capture():
	return false




