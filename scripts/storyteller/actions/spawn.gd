extends "res://scripts/storyteller/actions/abstract_action.gd"

var object_factory = preload('res://scripts/object_factory.gd').new()

func perform(action_details):
	var spawn_type
	var player
	var unit_type = action_details['unit']
	var side = action_details['side']

	var unit
	var field = self.bag.abstract_map.get_field(action_details['where'])

	if field.object != null:
		return

	if unit_type == 'soldier':
		spawn_type = 0
	elif unit_type == 'tank':
		spawn_type = 1
	elif unit_type == 'heli':
		spawn_type = 2

	if side == 'blue':
		player = 0
	elif side == 'red':
		player = 1

	unit = object_factory.build_unit(spawn_type, player)

	field.object = unit
	self.bag.controllers.action_controller.ysort.add_child(unit)
	self.bag.root.sound_controller.play_unit_sound(unit, self.bag.root.sound_controller.SOUND_SPAWN)
	unit.set_pos_map(field.position)

