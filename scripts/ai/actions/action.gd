var start       = Vector2(0,0)
var destination = null
var score       = 0
var path        = Vector2Array([])
var unit        = null
var group       = null
var type        = null
var fails       = 0
var proceed     = 0
var status      = 0

func _init(start, destination, unit, group):
    self.group = group
    self.start = start
    self.destination = destination
    self.unit = unit

func proceed():
    var path = Array(self.path)
    path.pop_front()
    self.path = Vector2Array(path)
    self.start = path[0]
    self.unit.add_move(path[0])
    self.proceed = self.proceed + 1

func fix_path(): #TODO - do it better maybe in pathfinding
    var path = Vector2Array([self.unit.position_on_map])
    path.append_array(self.path)
    self.path = path

func __info(string=''):
    if self.unit.type != 1:
        return
    print(string, self.__to_string())

func __to_string():
    var msg = "id: %5d t: %7s sc: %6.2f u: %5s d: %14s ap: %s p: %s proc: %s s: %s"
      #" u: " + self.unit + " d:" + self.destination + " p: " + self.path +" proc: " +self.proceed +" score: " + self.score
    return msg % [self.get_instance_ID(), self.type, self.score, self.unit.get_instance_ID(), self.destination, self.unit.ap, self.path, self.proceed, self.unit.position_on_map]
