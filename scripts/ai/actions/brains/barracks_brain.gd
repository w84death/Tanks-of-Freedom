extends "res://scripts/ai/actions/brains/building_brain.gd"


func _apply_amount_penalty(units):
	var counts = self._count_units(units)

	if counts["soldier"] > 10:
		return true

	return false
