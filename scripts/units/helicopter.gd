extends "behaviours.gd"

func _init():
	type = 2
	type_name = 'helicopter'

	life = 12
	max_life = 12
	attack = 5
	max_ap = 6
	attack_ap = 2
	max_attacks_number = 1
	ap = 6
	attacks_number = 1
	pass

func can_capture_building(building):
	return false

