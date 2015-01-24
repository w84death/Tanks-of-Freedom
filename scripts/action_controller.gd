
var root_node
var abstract_map = preload('abstract_map.gd').new()
var active_field = null

func handle_action(position):
	var field = abstract_map.get_field(position)
	
	if field.object != null:
		self.activate_field(field)
	else:
		if field != active_field && field.object == null:
			self.move_object(active_field, field)

func init_root(root):
	root_node = root
	abstract_map.tilemap = root.get_node("/root/game/pixel_scale/map")
	var units = root.get_tree().get_nodes_in_group("units")
	for unit in units:
		abstract_map.get_field(unit.get_pos_map()).object = unit

func activate_field(field):
	active_field = field
		
func move_object(from, to):
	to.object = from.object
	from.object = null
	active_field = to
	to.object.set_pos_map(to.position)