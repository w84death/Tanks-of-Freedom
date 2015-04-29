var unit
var path
var type
var abstract_map
var action_controller
var positions

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3
const ACTION_MOVE_TO_ATTACK = 4
const ACTION_MOVE_TO_CAPTURE = 5

func __get_next_tile_from_action():
	if path.size() == 0:
		return null

	return abstract_map.get_field(path[0])

func set_action_controller(controller):
	self.action_controller = controller

func set_positions(controller):
	self.positions = controller

func set_abstract_map(abs_map):
	self.abstract_map = abs_map

# just for debugging purporses
func get_action_name():
	if type == ACTION_MOVE:
		return 'MOVE'
	elif type == ACTION_CAPTURE:
		return 'CAPTURE'
	elif type == ACTION_SPAWN:
		return 'SPAWN'
	elif type == ACTION_MOVE_TO_ATTACK:
		return 'MOVE ATTACK'
	elif type == ACTION_MOVE_TO_CAPTURE:
		return 'MOVE CAPTURE'
	else:
		return 'ATTACK'