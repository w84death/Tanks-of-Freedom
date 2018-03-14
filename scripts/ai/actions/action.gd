var start       = Vector2(0,0)
var destination = null
var score       = 0
var path        = Vector2Array([])
var unit        = null
var group       = null
var type        = null
var fails       = 0
var status      = 0
var ttl         = null
var unused_ttl  = null
var invalid     = false

const DEFAULT_TTL = 100
const FLASH_TTL   = 1
const DEFAULT_UNUSED_TTL = 15

func _init(start, destination, unit, group, ttl = self.DEFAULT_TTL):
    self.group = group
    self.start = start
    self.destination = destination
    self.unit = unit
    self.type = type
    self.ttl = ttl
    self.unused_ttl = self.DEFAULT_UNUSED_TTL

func proceed():
    var path = Array(self.path)
    path.pop_front()
    self.path = Vector2Array(path)
    self.start = path[0]
    self.unit.add_move(path[0])

func is_unit_action():
    return self.group == 'unit'

func is_building_action():
    return self.group != 'unit'

func fix_path(): #TODO - do it better maybe in pathfinding
    var path = Vector2Array([self.unit.position_on_map])
    path.append_array(self.path)
    self.path = path

func add_age():
    if self.score == 0:
        self.unused_ttl = self.unused_ttl - 1
    else:
        self.unused_ttl = self.DEFAULT_UNUSED_TTL

    self.ttl = self.ttl - 1

func __info(string=''):
    if self.unit.type != 1:
        return

func __to_string():
    var msg = "id: %5d t: %7s sc: %6.2f u: %5s d: %8s ap: %s p: %s s: %s ttl: %s uttl: %s"
    var ap = 0;
    var dest = ''
    if self.unit.group != 'building':
        ap = self.unit.ap

    if self.destination != null:
        dest = self.destination.group

    return msg % [self.get_instance_ID(), self.type, self.score, self.unit.get_instance_ID(), dest, ap, self.path,  self.unit.position_on_map, self.ttl, self.unused_ttl]
