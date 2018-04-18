extends "res://scripts/ai/actions/types/move_action.gd"

var target

func _init(unit, path, target).(unit, path):
    self.score_cap = 1000
    self.target = target
