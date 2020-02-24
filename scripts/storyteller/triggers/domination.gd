extends "res://scripts/storyteller/triggers/abstract_trigger.gd"

func _initialize():
	self.trigger_types_used['claim'] = true

func is_triggered(trigger_details, story_event):
	var player = trigger_details['details']['player']
	var list = trigger_details['details']['list']
	var amount = trigger_details['details']['amount']
	var field
	var count = 0

	for positionVAR in list:
		field = self.bag.abstract_map.get_field(positionVAR)
		if field.object.player == player:
			count = count + 1

	if count >= amount:
		return true

	return false
