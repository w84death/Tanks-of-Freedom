export var position_on_map = Vector2(0,0)
var group = 'waypoint'
var type  = 10

func _init(pos):
    self.position_on_map = pos

func get_pos_map():
    return position_on_map
