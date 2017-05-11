var unit
var path
var bag
var type

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3
const ACTION_MOVE_TO_ATTACK = 4
const ACTION_MOVE_TO_CAPTURE = 5

func __get_next_tile_from_action():
    if path.size() == 0:
        return null

    return self.bag.abstract_map.get_field(path[0])

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