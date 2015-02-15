extends "behaviours.gd"

func _init():
	type = 2

	life = 12
	max_life = 12
	attack = 5
	plain = 1
	road = 1
	river = 1
	max_ap = 10
	attack_ap = 2
	max_attacks_number = 1
	ap = 10
	attacks_number = 1
	pass

func can_capture_building(building):
	return false

