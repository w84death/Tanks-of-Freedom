extends "behaviours.gd"

func _init():
	type = 0
	type_name = 'soldier'

	life = 8
	max_life = 8
	attack = 5
	plain = 2
	road = 1
	river = 4
	max_ap = 8
	attack_ap = 2
	max_attacks_number = 1
	ap = 8
	attacks_number = 1
	pass

func can_capture_building(building):
	if building.player == player:
		return false

	var type = building.get_building_name()
	if type == "BUNKER":
		return true
	if type == "BARRACKS":
		return true
	if type == "FACTORY":
		return true
	if type == "AIRPORT":
		return true
	if type == "HQ":
		return true
	if type == "GSM TOWER":
		return true

	return false;

