extends "res://scripts/storyteller/triggers/abstract_trigger.gd"

func _initialize():
	self.trigger_types_used['die'] = true

func mark_actors(trigger_details):
	var vip

	vip = trigger_details['details']['vip']
	self._mark_actor(vip, self._create_vip_mark(vip))


func is_triggered(trigger_details, story_event):
	var mark
	var victim = story_event['details']['victim']

	mark = self._create_vip_mark(trigger_details['details']['vip'])

	if victim.has(mark):
		return true

	return false

func _create_vip_mark(vip):
	return "vip_" + str(vip.x) + "_" + str(vip.y)
