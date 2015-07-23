
var root

var controllers = preload("res://scripts/controllers/controllers.gd").new()

var map_list = preload("res://scripts/maps/map_list.gd").new()
var campaign = preload("res://maps/campaign.gd").new()
var abstract_map = preload('res://scripts/abstract_map.gd').new()
var match_state = preload("res://scripts/match_state.gd").new()
var demo_mode = preload("res://scripts/demo_mode.gd").new()
var camera = preload("res://scripts/camera.gd").new()
var hud_dead_zone = preload("res://scripts/services/hud_dead_zone.gd").new()
var workshop_dead_zone = preload("res://scripts/services/workshop_dead_zone.gd").new()
var workshop = preload("res://gui/workshop/workshop.xscn").instance()
var ap_gain = preload("res://gui/hud/ap_gain.gd").new()
var positions

func init_root(root_node):
	self.root = root_node
	self.positions = preload("services/positions.gd").new(self.root)
	self.demo_mode.init_root(root_node)
	self.campaign.load_campaign_progress()
	self.positions.prepare_nearby_tiles()
	self.camera.abstract_map = self.abstract_map
	self.camera.init_root(root)
	self.controllers.campaign_menu_controller.init_root(root_node)
	self.controllers.hud_panel_controller.init_root(root_node)
	self.controllers.workshop_gui_controller.init_root(root_node)
	self.workshop.init(self.root)
	self.hud_dead_zone.init_root(root_node)
	self.workshop_dead_zone.init_root(root_node)
	self.ap_gain.init_root(root_node)
	self.camera.workshop_camera = self.workshop.game_scale
	self.camera.workshop_map = self.workshop.map
	self.camera.apply_default_camera()
	self.map_list.init()