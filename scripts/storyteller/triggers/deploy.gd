extends "res://scripts/storyteller/triggers/abstract_trigger.gd"

func _initialize():
	self.trigger_types_used['deploy'] = true
	self.trigger_types_used['die'] = true

func is_triggered(trigger_details, story_event):
	var player = trigger_details['details']['player']
	var unit_type = null
	var exact = false
	var amount = trigger_details['details']['amount']
	var count = 0

	if trigger_details['details'].has('type'):
		unit_type = trigger_details['details']['type']
	if trigger_details['details'].has('exact'):
		exact = trigger_details['details']['exact']

	var units = self.bag.positions.get_player_units(player)
	var field

	for unit_position in units:
		if unit_type == null:
			count = count + 1
		else:
			field = self.bag.abstract_map.get_field(unit_position)
			if field.object == null:
				continue
			if field.object.type_name == unit_type:
				count = count + 1

	if exact:
		if count == amount:
			return true
	else:
		if count >= amount:
			return true

	return false