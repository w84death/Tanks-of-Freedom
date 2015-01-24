
var root_node
var abstract_map = preload('abstract_map.gd').new()
var active_field = null
var active_indicator = preload('res://units/selector.xscn').instance()
var battle_controller = preload('battle_controller.gd').new()
var movement_controller = preload('movement_controller.gd').new()

var current_player = 1

func handle_action(position):
	var field = abstract_map.get_field(position)
	
	if field.object != null:
		if active_field != null:
			if field.object.group == 'unit' && active_field.object.group == 'unit':
				if active_field.is_adjacent(field) && field.object.player != current_player && active_field.object.can_attack(field.object):
					if (battle_controller.resolve_fight(active_field.object, field.object)):
						self.despawn_unit(field)
						return
					
			if field == active_field && field.object.group == 'building':
				var spawn_point = abstract_map.get_field(field.object.spawn_point)
				if spawn_point.object == null:
					var unit = field.object.spawn_unit(current_player)
					abstract_map.tilemap.add_child(unit)
					unit.set_pos_map(spawn_point.position)
					spawn_point.object = unit
			if active_field.object.group == 'unit' && active_field.object.type == 0 && field.object.group == 'building' && field.object.player != current_player:
				if active_field.is_adjacent(field):
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
	active_indicator.set_region_rect(Rect2(32, 0, 32, 32))
	self.import_objects()

func activate_field(field):
	active_field = field
	abstract_map.tilemap.add_child(active_indicator)
	var position = Vector2(abstract_map.tilemap.map_to_world(field.position))
	position.y += 2
	active_indicator.set_pos(position)

func clear_active_field():
	active_field = null
	abstract_map.tilemap.remove_child(active_indicator)

func despawn_unit(field):
	abstract_map.tilemap.remove_child(field.object)
	field.object.queue_free()
	field.object = null
	
func import_objects():
	self.attach_objects(root_node.get_tree().get_nodes_in_group("units"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("buildings"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("terrain"))

func attach_objects(collection):
	for entity in collection:
		abstract_map.get_field(entity.get_initial_pos()).object = entity
