
var root

var map_list = preload("res://scripts/maps/map_list.gd").new()
var position_controller

func init_root(root_node):
	self.root = root_node

	position_controller = preload("position_controller.gd").new(self.root)

	map_list.init()