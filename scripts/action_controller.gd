
var root_node
var abstract_map = preload('abstract_map.gd').new()

func handle_action(position):
	var field = abstract_map.get_field(position)
	print(field.position)

func init_root(root):
	root_node = root
	abstract_map.tilemap = root.get_node("/root/game/pixel_scale/map")