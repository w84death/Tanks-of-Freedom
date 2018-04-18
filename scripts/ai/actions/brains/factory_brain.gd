extends "res://scripts/ai/actions/brains/building_brain.gd"

func _initialize():
    ._initialize()
    self.base_spawn_score = 110


func _apply_amount_penalty(units):
    var counts = self._count_units(units)

    if counts["tank"] > int(counts["soldier"] * 1.5):
        return true

    return false
