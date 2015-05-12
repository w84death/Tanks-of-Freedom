
var root

var map_list = preload("res://scripts/maps/map_list.gd").new()
var campaign = preload("res://maps/campaign.gd").new()
var positions

func init_root(root_node):
	self.root = root_node
	positions = preload("services/positions.gd").new(self.root)

	map_list.init()