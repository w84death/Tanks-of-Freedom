export var position_on_map = Vector2(0,0)
var group = 'waypoint'
var type  = 10
var subtype = null
var for_unit_types = [0, 1, 2]

const TYPE_LEVEL_1 = 1
const TYPE_LEVEL_2 = 2
const TYPE_LEVEL_3 = 3
const TYPE_BULDING_AREA = 10
const TYPE_SPAWN_POINT = 11

func _init(pos, subtype=self.TYPE_LEVEL_1):
    self.position_on_map = pos
    self.subtype = subtype

func get_pos_map():
    return position_on_map
