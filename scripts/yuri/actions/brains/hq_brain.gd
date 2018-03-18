extends "res://scripts/yuri/actions/brains/building_brain.gd"

func _initialize():
    ._initialize()
    self.base_spawn_score = 50
    self.in_danger_score = 140
    self.unit_amount_penalty = 50


func _apply_amount_penalty(units):
    var counts = self._count_units(units)

    if counts["soldier"] > 5:
        return true

    return false
