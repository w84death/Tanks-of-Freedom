extends "res://scripts/ai/actions/action_object.gd"

func _init(unit, path):
	self.type = ACTION_SPAWN
	self.unit = unit
	self.path = path

func execute():
	action_controller.set_active_field(unit.get_pos_map())
	action_controller.spawn_unit_from_active_building()
	return true