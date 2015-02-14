extends "behaviours.gd"

func _init():
	type = 2

	life = 10
	max_life = 10
	attack = 4
	plain = 1
	road = 1
	river = 1
	max_ap = 8
	attack_ap = 2
	max_attacks_number = 1
	ap = 8
	attacks_number = 1
	pass

func can_capture_building(building):
	return false

