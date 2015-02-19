var unit
var path
var type

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3
const ACTION_MOVE_TO_ATTACK = 4
const ACTION_MOVE_TO_CAPTURE = 5

func _init(unit, path, action_type):
	self.unit = unit
	self.path = path
	self.type = action_type

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