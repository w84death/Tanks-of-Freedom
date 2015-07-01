extends "behaviours.gd"

func _init():
	type = 2
	type_name = 'helicopter'

	life = 15
	max_life = 15
	attack = 8
	max_ap = 10
	attack_ap = 2
	max_attacks_number = 1
	ap = 10
	attacks_number = 1
	pass

func can_capture_building(building):
	return false

