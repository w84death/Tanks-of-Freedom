extends "behaviours.gd"

func _init():
	type = 0
	type_name = 'soldier'
	type_name_label = 'LABEL_WORKSHOP_INFANTRY'

	life = 10
	max_life = 10
	attack = 5
	max_ap = 4
	limited_ap = 3
	attack_ap = 1
	max_attacks_number = 1
	ap = 4
	attacks_number = 1
	visibility = 3

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

