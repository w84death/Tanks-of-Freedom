
extends AnimatedSprite

export var player = -1
export var position_on_map = Vector2(0,0)
var current_map
var health_bar
var type = 0

var life
var max_life
var attack
var plain
var road
var river
var max_ap
var attack_ap
var max_attacks_number
var ap
var attacks_number

var group = 'unit'

var explosion_template = preload('res://particle/explosion.xscn')
var explosion

func get_player():
	return player

func get_type():
	return type

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
	
func show_explosion():
	explosion = explosion_template.instance()
	explosion.unit = self
	self.add_child(explosion)
	
func clear_explosion():
	self.remove_child(explosion)
	explosion.queue_free()

func _ready():
	add_to_group("units")
	get_node('anim').play("move")
	current_map = get_node("/root/game").current_map_terrain
	health_bar = get_node("health")
	pass


