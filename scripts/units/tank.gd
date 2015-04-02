extends "behaviours.gd"

func _init():
	type = 1
	type_name = 'tank'

	life = 15
	max_life = 15
	attack = 9
	plain = 2
	road = 1
	river = 6
	max_ap = 8
	attack_ap = 3
	max_attacks_number = 1
	ap = 8
	attacks_number = 1
	pass

func can_capture_building(building):
	return false



