
extends Sprite
export var position_on_map = Vector2(0,0)
export var type = 0
export var player = -1

var current_map
var group = 'building'
var spawn_point = Vector2(0, 0)

var object_factory = preload('object_factory.gd').new()

var TYPE_BUNKER = 0;
var TYPE_BARRACKS = 1;
var TYPE_FACTORY = 2;
var TYPE_AIRPORT = 3;

func get_pos_map():
	return position_on_map
	
func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos()) + Vector2(1, 1)
	spawn_point = Vector2(position_on_map) + Vector2(0, 1)
	return position_on_map

func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position
	spawn_point = Vector2(position_on_map) + Vector2(0, 1)

func claim(new_player):
	if new_player == -1:
		self.set_frame(0)
	if new_player == 0:
		self.set_frame(1)
	if new_player == 1:
		self.set_frame(2)
	
	player = new_player

func get_player():
	return player
	
func set_frame(number):
	var current_frame = get_region_rect()
	var new_frame = Rect2(number * 32, current_frame.pos.y, 32, 32)
	set_region_rect(new_frame)
	
func spawn_unit(player):
	var unit = null
	if type == TYPE_BUNKER || type == TYPE_BARRACKS:
		unit = object_factory.build_unit(0, player)
	if type == TYPE_FACTORY:
		unit = object_factory.build_unit(1, player)
	if type == TYPE_AIRPORT:
		unit = object_factory.build_unit(2, player)
		
	return unit

func get_required_ap():
	if type == TYPE_BARRACKS:
		return 4
	if type == TYPE_FACTORY:
		return 8
	if type == TYPE_AIRPORT:
		return 12
	if type == TYPE_BUNKER:
		return 8

	return 0
	
func get_name():
	if type == TYPE_BUNKER:
		return "BUNKER"
	if type == TYPE_BARRACKS:
		return "BARRACKS"
	if type == TYPE_FACTORY:
		return "FACTORY"
	if type == TYPE_AIRPORT:
		return "AIRFIELD"

func get_cost():
	return get_required_ap()

func _ready():
	add_to_group("buildings")
	current_map = get_node("/root/game/pixel_scale/map")
	pass


