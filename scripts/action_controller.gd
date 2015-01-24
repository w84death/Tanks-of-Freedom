
var root_node
var abstract_map = preload('abstract_map.gd').new()
var active_field = null
var active_indicator = preload('res://units/selector.xscn').instance()
var damage = preload('damage.gd')
var object_factory = preload('object_factory.gd').new()

func handle_action(position):
	var field = abstract_map.get_field(position)
	print(field.object)
	if field.object != null:
		if(active_field != null && active_field.is_adjacent(field)):
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

func move_object(from, to):
	to.object = from.object
	from.object = null
	to.object.set_pos_map(to.position)
	
func import_objects():
	self.attach_objects(root_node.get_tree().get_nodes_in_group("units"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("buildings"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("terrain"))

func attach_objects(collection):
	for entity in collection:
		abstract_map.get_field(entity.get_initial_pos()).object = entity
