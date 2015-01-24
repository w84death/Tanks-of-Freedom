
var root_node
var abstract_map = preload('abstract_map.gd').new()
var active_field = null
var active_indicator = preload('res://units/player_red.scn').instance()
var damage = preload('damage.gd')

func handle_action(position):
	var field = abstract_map.get_field(position)

	if field.object != null:
		if(active_field != null):
			damage.resolve_fight(active_field.object, field.object)
		else:
			self.activate_field(field)
	else:
		if active_field != null && active_field.object != null && field != active_field && field.object == null:
			if (active_field.is_adjacent(field)):
				self.move_object(active_field, field)
				self.activate_field(field)

func init_root(root):
	root_node = root
	abstract_map.tilemap = root.get_node("/root/game/pixel_scale/map")
	var units = root.get_tree().get_nodes_in_group("units")
	for unit in units:
		abstract_map.get_field(unit.get_pos_map()).object = unit
	active_indicator.set_region_rect(Rect2(32, 0, 32, 32))

func activate_field(field):
	active_field = field
	abstract_map.tilemap.add_child(active_indicator)
	var position = Vector2(abstract_map.tilemap.map_to_world(field.position))
	position.y += 2
	active_indicator.set_pos(position)

func clear_active_field():
	active_field = null
	abstract_map.tilemap.remove_child(active_indicator)

func move_object(from, to):
	to.object = from.object
	from.object = null
	to.object.set_pos_map(to.position)
