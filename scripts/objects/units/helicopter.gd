extends "unit.gd"

func _init():
	type = 2
	type_name = 'heli'
	type_name_label = 'LABEL_WORKSHOP_HELI'

	life = 10
	max_life = 10
	attack = 8
	max_ap = 8
	limited_ap = 6
	attack_ap = 1
	max_attacks_number = 1
	ap = 8
	attacks_number = 1
	visibility = 5

func can_capture_building(building):
	return false

