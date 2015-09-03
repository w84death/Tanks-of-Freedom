
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
var action_map = preload('res://scripts/action_map.gd').new()
var battle_controller = preload('res://scripts/battle_controller.gd').new()
var movement_controller = preload('res://scripts/movement_controller.gd').new()
var ap_gain = preload("res://gui/hud/ap_gain.gd").new()
var map_tiles = preload("res://scripts/maps/map_tiles.gd").new()
var positions
var migrations = preload("res://scripts/migrations/migrations.gd").new()
var timers = preload("res://scripts/timers.gd").new()
var menu_background_map = preload("res://maps/menu_map_background.gd").new()
var helpers = preload("res://scripts/services/helpers.gd").new()
var raycasting = preload("res://scripts/services/raycasting.gd").new()
var map_picker = preload("res://gui/hud/map_picker.gd").new()
var skirmish_setup = preload("res://gui/hud/skirmish_setup_panel.gd").new()

func init_root(root_node):
    self.root = root_node
    self.positions = preload("services/positions.gd").new(self.root)
    self.positions.prepare_nearby_tiles()
    self.positions.prepare_nearby_tiles_ranges()

    self.demo_mode.init_root(root_node)
    self.campaign.load_campaign_progress()
    self.camera.abstract_map = self.abstract_map
    self.camera.init_root(root)
    self.controllers.campaign_menu_controller.init_root(root_node)
    self.controllers.hud_panel_controller.init_root(root_node)
    self.controllers.workshop_gui_controller.init_root(root_node)
    self.workshop.init(self.root)
    self.hud_dead_zone.init_root(root_node)
    self.workshop_dead_zone.init_root(root_node)
    self.action_map.init_root(root_node)
    self.ap_gain.init_root(root_node)
    self.camera.workshop_camera = self.workshop.game_scale
    self.camera.workshop_map = self.workshop.map
    self.camera.apply_default_camera()
    self.map_list.init()
    self.migrations.init_bag(self)
    self.timers._init_bag(self)
    self.map_picker._init_bag(self)
    self.skirmish_setup._init_bag(self)
