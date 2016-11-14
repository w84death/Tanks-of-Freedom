
extends Sprite
export var position_on_map = Vector2(0,0)
export var type = 0
export var player = -1
export var bonus_ap = 1
export var can_spawn = true

var current_map
var group = 'building'
var spawn_point = Vector2(0, 0)
var spawn_field = null
export var spawn_point_position = Vector2(0, 1)
var flag
var turn_claimed = -1

var object_factory = preload('object_factory.gd').new()

var floating_ap_template = preload('res://particle/hit_points.xscn')
var floating_ap

var TYPE_BUNKER = 0
var TYPE_BARRACKS = 1
var TYPE_FACTORY = 2
var TYPE_AIRPORT = 3
var TYPE_TOWER = 4

const HAS_SAME_TYPE_OF_UNIT_MODIFIER = 3
const IN_DANGER_MODIFIER  = 5

func get_pos_map():
	return position_on_map

func get_spawn_point_pos():
	return spawn_point

func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos())
	spawn_point = Vector2(position_on_map) + spawn_point_position
	return position_on_map

func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position
	spawn_point = Vector2(position_on_map) + spawn_point_position

func claim(new_player, turn):
	if new_player == -1:
		self.set_frame(0)
	if new_player == 0:
		self.set_frame(1)
	if new_player == 1:
		self.set_frame(2)

	player = new_player
	self.turn_claimed = turn
	flag.change_flag(new_player)

func get_player():
	return player

func set_frame(number):
	var current_frame = get_region_rect()
	var new_frame = Rect2(number * 64, current_frame.pos.y, 64, 64)
	set_region_rect(new_frame)

func get_spawn_type():
	if type == TYPE_BUNKER || type == TYPE_BARRACKS:
		return 0
	if type == TYPE_FACTORY:
		return 1
	if type == TYPE_AIRPORT:
		return 2

func spawn_unit(player):
	var unit_type = self.get_spawn_type()
	if unit_type != null:
		return object_factory.build_unit(unit_type, player)

	return null

func get_required_ap():
	if type == TYPE_BARRACKS:
		return 25
	if type == TYPE_FACTORY:
		return 50
	if type == TYPE_AIRPORT:
		return 70
	if type == TYPE_BUNKER:
		return 40

	return 0

func get_building_name():
	if type == TYPE_BUNKER:
		return "HQ"
	if type == TYPE_BARRACKS:
		return "BARRACKS"
	if type == TYPE_FACTORY:
		return "FACTORY"
	if type == TYPE_AIRPORT:
		return "AIRPORT"
	if type == TYPE_TOWER:
		return "GSM TOWER"

func get_cost():
	return get_required_ap()

func estimate_action(action_type, enemy_units_nearby, own_units, current_player_ap, SPAWN_LIMIT):
	var score = 120
	score = score + enemy_units_nearby.size() * IN_DANGER_MODIFIER
	if (own_units.size() >= SPAWN_LIMIT):
		score = score - 120
	elif (own_units.size() > (SPAWN_LIMIT / 2)):
		score = score - 60

	var spawn_unit_type = self.get_spawn_type()
	var same_units_count = 0
	for unit in own_units.values():
		if unit.get_type() == spawn_unit_type:
			same_units_count = same_units_count + 1

	if (same_units_count == 0):
		score = score + 80
	else:
		score = score - 10 * same_units_count

	if current_player_ap > 200:
		score = score + self.get_required_ap() * 4
	elif current_player_ap > 100:
		score = score + self.get_required_ap() * 2
	elif current_player_ap > 50:
		score = score + self.get_required_ap()

	return score

func show_floating_ap():
	floating_ap = floating_ap_template.instance()
	floating_ap.set_text(str(bonus_ap))
	floating_ap.unit = self
	floating_ap.show_ap_icon()
	self.add_child(floating_ap)

func clear_floating_damage():
	self.remove_child(floating_ap)
	floating_ap.queue_free()


func _ready():
	add_to_group("buildings")
	if get_node("/root/game"):
		current_map = get_node("/root/game").current_map_terrain
	flag = get_node('flag')
	pass


