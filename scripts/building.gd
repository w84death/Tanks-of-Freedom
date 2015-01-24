
extends Sprite
export var position_on_map = Vector2(0,0)
export var type = 0
export var player = 0

var current_map
var group = 'building'

func get_pos_map():
	return position_on_map
	
func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos()) + Vector2(1, 1)
	return position_on_map

	
func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position

func _ready():
	add_to_group("buildings")
	current_map = get_node("/root/game/pixel_scale/map")
	pass


