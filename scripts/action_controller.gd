
var root_node
var abstract_map = preload('abstract_map.gd').new()

func handle_action(position):
	var field = abstract_map.get_field(position)
	print(field.object)

func init_root(root):
	root_node = root
	abstract_map.tilemap = root.get_node("/root/game/pixel_scale/map")
	var units = root.get_tree().get_nodes_in_group("units")
	for unit in units:
		abstract_map.get_field(unit.get_pos_map()).object = unit