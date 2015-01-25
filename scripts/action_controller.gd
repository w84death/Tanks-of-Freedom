
var root_node
var abstract_map = preload('abstract_map.gd').new()
var selector
var active_field = null
var active_indicator = preload('res://units/selector.xscn').instance()
var battle_controller = preload('battle_controller.gd').new()
var movement_controller = preload('movement_controller.gd').new()
var hud_controller = preload('hud_controller.gd').new()

var current_player = 1
var player_ap = 10
var player_ap_max = 10

func handle_action(position):
	var field = abstract_map.get_field(position)
	
	if field.object != null:
		if active_field != null:
			if field.object.group == 'unit' && active_field.object.group == 'unit':
				if active_field.is_adjacent(field) && field.object.player != current_player:
					if (battle_controller.resolve_fight(active_field.object, field.object)):
						self.despawn_unit(field)
						hud_controller.update_unit_card(active_field.object)
						return
					hud_controller.update_unit_card(active_field.object)
					
			if active_field.object.group == 'unit' && active_field.object.type == 0 && field.object.group == 'building' && field.object.player != current_player:
				if active_field.is_adjacent(field) && movement_controller.can_move(active_field, field):
					field.object.claim(current_player)
					self.despawn_unit(active_field)
					self.activate_field(field)
		if (field.object.group == 'unit' || field.object.group == 'building') && field.object.player == current_player:
			self.activate_field(field)
	else:
		if active_field != null && active_field.object != null && field != active_field && field.object == null:
			if (active_field.object.group == 'unit' && active_field.is_adjacent(field) && field.terrain_type != -1):
				if(movement_controller.move_object(active_field, field)):
					self.activate_field(field)

func init_root(root):
	root_node = root
	abstract_map.tilemap = root.get_node("/root/game/pixel_scale/map")
	selector = root.get_node('/root/game/pixel_scale/map/YSort/selector')
	active_indicator.set_region_rect(Rect2(64, 0, 32, 32))
	self.import_objects()
	hud_controller.init_root(root, self)

func activate_field(field):
	self.clear_active_field()
	active_field = field
	abstract_map.tilemap.add_child(active_indicator)
	var position = Vector2(abstract_map.tilemap.map_to_world(field.position))
	position.y += 2
	active_indicator.set_pos(position)
	if field.object.group == 'unit':
		hud_controller.show_unit_card(field.object)
	if field.object.group == 'building':
		hud_controller.show_building_card(field.object)

func clear_active_field():
	active_field = null
	abstract_map.tilemap.remove_child(active_indicator)
	hud_controller.clear_unit_card()
	hud_controller.clear_building_card()

func despawn_unit(field):
	abstract_map.tilemap.remove_child(field.object)
	field.object.queue_free()
	field.object = null

func spawn_unit_from_active_building():
	if active_field == null || active_field.object.group != 'building':
		return
	var spawn_point = abstract_map.get_field(active_field.object.spawn_point)
	if spawn_point.object == null:
		var unit = active_field.object.spawn_unit(current_player)
		abstract_map.tilemap.add_child(unit)
		unit.set_pos_map(spawn_point.position)
		spawn_point.object = unit

func import_objects():
	self.attach_objects(root_node.get_tree().get_nodes_in_group("units"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("buildings"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("terrain"))

func attach_objects(collection):
	for entity in collection:
		abstract_map.get_field(entity.get_initial_pos()).object = entity
		
func end_turn():
	if current_player == 0:
		self.switch_to_player(1)
	else:
		self.switch_to_player(0)
	player_ap = player_ap_max

func has_ap():
	if player_ap > 0:
		return true
	return false

func use_ap():
	player_ap -= 1

func switch_to_player(player):
	self.clear_active_field()
	current_player = player
	self.reset_player_units(player)
	selector.set_region_rect(Rect2(player * 32, 0, 32, 32))

func reset_player_units(player):
	var units = root_node.get_tree().get_nodes_in_group("units")
	for unit in units:
		if unit.player == player:
			unit.reset_ap()
