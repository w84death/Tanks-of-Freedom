extends "res://scripts/ai/actions/brains/building_brain.gd"

func _initialize():
	._initialize()
	self.base_spawn_score = 120
	self.in_danger_score = 60
	self.unit_amount_penalty = 80


func _apply_amount_penalty(units):
	var counts = self._count_units(units)

	if int(counts["tank"] / 3) < counts["heli"]:
		return true

	return false
