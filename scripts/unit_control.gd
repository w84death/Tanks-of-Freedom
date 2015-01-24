
extends AnimatedSprite
export var position_on_map = Vector2(0,0)
export var player = -1
export var type = 0

export var life = 2
export var attack = 3
export var plain = 2
export var road = 2
export var river = 3
export var max_ap = 8
var ap = 8


var current_map

var group = 'unit'

func get_pos_map():
	return position_on_map
	
func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos())
	return position_on_map

func get_stats():
	return {'life' : life, 'attack' : attack, 'plain' : plain, 'road' : road, 'river' : river, 'ap' : ap}

func set_stats(new_stats):
	life = new_stats.life
	attack = new_stats.attack
	ap = new_stats.ap

func reset_ap():
	ap = max_ap
	
func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position

func die():
	print('DIED!')

func can_attack(enemy):
	if type == 1 && enemy.type == 2:
		return false
	return true

func set_damaged():
	print('DAMAGED!')

func _ready():
	add_to_group("units")
	get_node('anim').play("move")
	current_map = get_node("/root/game/pixel_scale/map")
	pass


