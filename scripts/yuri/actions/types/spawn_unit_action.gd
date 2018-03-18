extends "res://scripts/yuri/actions/types/base_action.gd"

var building

func _init(building):
    self.building = building
    self.score_cap = 300
