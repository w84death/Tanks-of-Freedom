extends "res://scripts/bag_aware.gd"

var trigger_types_used = {}

func uses(event_type):
	return self.trigger_types_used.has(event_type)

func is_triggered(trigger_details, story_event):
	return

func mark_actors(trigger_details):
	return

func _mark_actor(positionVAR, mark):
	var field

	field = self.bag.abstract_map.get_field(positionVAR)
	field.object.story_markers[mark] = mark

