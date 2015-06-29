extends "behaviours.gd"

func _init():
	type = 1
	type_name = 'tank'

	life = 15
	max_life = 15
	attack = 9
	max_ap = 4
	attack_ap = 2
	max_attacks_number = 1
	ap = 4
	attacks_number = 1
	pass

func can_capture_building(building):
	return false



