
extends AnimatedSprite
export var position_on_map = Vector2(0,0)
export var player = -1
export var type = 0

var current_map

var group = 'unit'

var stats = {
	life      = 2,
	attack    = 3,
	plain     = 2,
	road      = 1,
	river     = 3,
	ap        = 8
}

func get_pos_map():
	return position_on_map
	
func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos())
	return position_on_map

func get_stats():
	return stats

func set_stats(new_stats):
	stats = new_stats
	
func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position

func die():
	print('DIED!')


func set_damaged():
	print('DAMAGED!')

func _ready():
	add_to_group("units")
	get_node('anim').play("move")
	current_map = get_node("/root/game/pixel_scale/map")
	pass


