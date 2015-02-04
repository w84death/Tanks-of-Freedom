
extends AnimatedSprite
export var position_on_map = Vector2(0,0)
export var player = -1
export var type = 0

export var life = 2
export var max_life = 10
export var attack = 3
export var plain = 2
export var road = 2
export var river = 3
export var max_ap = 8
export var attack_ap = 2
export var max_attacks_number = 1
var ap = 8
var attacks_number = 1

var current_map
var health_bar

var group = 'unit'

func get_player():
	return player
	
func get_pos_map():
	return position_on_map
	
func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos())
	return position_on_map

func get_stats():
	return {'life' : life, 'attack' : attack, 'plain' : plain, 'road' : road, 'river' : river, 'ap' : ap, 'attack_ap': attack_ap, 'attacks_number' : attacks_number}

func set_stats(new_stats):
	life = new_stats.life
	attack = new_stats.attack
	ap = new_stats.ap
	attacks_number = new_stats.attacks_number
	update_healthbar()

func reset_ap():
	ap = max_ap
	attacks_number = max_attacks_number
	
func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position
	
func can_attack():
	if ap >= attack_ap && attacks_number > 0:
		return true
	return false

func die():
	print('DIED!')

func set_damaged():
	print('DAMAGED!')
	
func update_healthbar():
	var frame = health_bar.get_frame()
	if self.life <= 2:
		health_bar.set_frame(2)
	elif self.life <= 7:
		health_bar.set_frame(1)
	else:
		health_bar.set_frame(0)
	return

func _ready():
	add_to_group("units")
	get_node('anim').play("move")
	current_map = get_node("/root/game/pixel_scale/map")
	health_bar = get_node("health")
	pass


