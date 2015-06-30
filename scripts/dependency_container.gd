
var root

var controllers = preload("res://scripts/controllers/controllers.gd").new()

var map_list = preload("res://scripts/maps/map_list.gd").new()
var campaign = preload("res://maps/campaign.gd").new()
var abstract_map = preload('res://scripts/abstract_map.gd').new()
var positions

func init_root(root_node):
	self.root = root_node
	self.positions = preload("services/positions.gd").new(self.root)
	self.controllers.campaign_menu_controller.init_root(root_node)

	map_list.init()