var root

var controllers = load("res://scripts/controllers/controllers.gd").new()

var language = load("res://scripts/language.gd").new()
var map_list = load("res://scripts/maps/map_list.gd").new()
var campaign = load("res://maps/campaign.gd").new()
var abstract_map = load('res://scripts/abstract_map.gd').new()
var match_state = load("res://scripts/match_state.gd").new()
var demo_mode = load("res://scripts/demo_mode.gd").new()
var camera = load("res://scripts/camera.gd").new()
var hud_dead_zone = load("res://scripts/services/hud_dead_zone.gd").new()
var workshop_dead_zone = load("res://scripts/services/workshop_dead_zone.gd").new()
var menu_back = load("res://scripts/menu_back.gd").new()

var action_map = load('res://scripts/action_map.gd').new()
var battle_controller = load('res://scripts/battle_controller.gd').new()
var movement_controller = load('res://scripts/movement_controller.gd').new()
var ap_gain = load("res://gui/hud/ap_gain.gd").new()
var map_tiles = load("res://scripts/maps/map_tiles.gd").new()
var positions = load('res://scripts/services/positions.gd').new()
var migrations = load("res://scripts/migrations/migrations.gd").new()
var timers = load("res://scripts/timers.gd").new()
var menu_background_map = load("res://maps/menu_map_background.gd").new()
var helpers = load("res://scripts/services/helpers.gd").new()
var fog_controller = load('res://scripts/fog_controller.gd').new()
var processing = load('res://scripts/processing.gd').new()
var file_handler = load('res://scripts/services/file_handler.gd').new()

var map_picker = load("res://gui/hud/map_picker.gd").new()
var skirmish_setup = load("res://gui/hud/skirmish_setup_panel.gd").new()
var confirm_popup = load("res://scripts/popups/confirm.gd").new()
var prompt_popup = load("res://scripts/popups/prompt.gd").new()
var message_popup = load("res://scripts/popups/message.gd").new()
var message_big_popup = load("res://scripts/popups/big_message.gd").new()
var gamepad_popup = load("res://scripts/popups/gamepad_info.gd").new()

var resolution = load('res://scripts/services/resolution.gd').new()
var gamepad = load('res://scripts/gamepad_input.gd').new()
var pandora = load('res://scripts/pandora_input.gd').new()
var unit_switcher = load('res://scripts/unit_switcher.gd').new()

var online_request = load('res://scripts/online/request.gd').new()
var online_request_async = load('res://scripts/online/request_async.gd').new()
var online_player = load('res://scripts/online/player.gd').new()
var online_maps = load('res://scripts/online/maps.gd').new()
var online_multiplayer = load('res://scripts/online/multiplayer.gd').new()
var tileset_handler = load('res://scripts/services/tileset_handler.gd').new()
var script_player = load('res://scripts/services/script_player.gd').new()
var battle_stats = load("res://scripts/battle_stats.gd").new()
var game_conditions = load("res://scripts/game_conditions.gd").new()
var ai = load("res://scripts/ai/ai.gd").new()
var perform = load("res://scripts/ai/perform.gd").new()
var logger = load('res://scripts/services/logger.gd').new()
var storyteller = load("res://scripts/storyteller/storyteller.gd").new()
var waypoint_factory = load("res://scripts/objects/waypoints/waypoint_factory.gd").new()

var saving = null
var workshop = null

func init_root(root_node):
	self.root = root_node

	self.language._init_bag(self)
	self.migrations._init_bag(self)
	self.map_list._init_bag(self)
	self.campaign.load_campaign_progress()

	if ProjectSettings.get_setting('tof/enable_workshop'):
		self.controllers.workshop_gui_controller = load("res://scripts/controllers/workshop_gui_controller.gd").new()
		self.workshop = load("res://gui/workshop/workshop.tscn").instance()
		self.controllers.workshop_gui_controller.init_root(root_node)
		self.workshop.init(self.root)

	self.controllers.campaign_menu_controller.init_root(root_node)
	self.controllers.hud_panel_controller.init_root(root_node)
	self.controllers.workshop_menu_controller.init_root(root_node)
	self.controllers.background_map_controller.init_root(root_node)
	self.controllers.online_menu_controller._init_bag(self)

	self.menu_back._init_bag(self)
	self.hud_dead_zone.init_root(root_node)
	self.workshop_dead_zone.init_root(root_node)

	self.positions._init_bag(self)
	self.demo_mode._init_bag(self)
	self.action_map._init_bag(self)
	self.ap_gain._init_bag(self)

	self.unit_switcher._init_bag(self)
	self.camera._init_bag(self)
	self.timers._init_bag(self)
	self.map_picker._init_bag(self)
	self.confirm_popup._init_bag(self)
	self.prompt_popup._init_bag(self)
	self.message_popup._init_bag(self)
	self.message_big_popup._init_bag(self)
	self.gamepad_popup._init_bag(self)
	self.skirmish_setup._init_bag(self)
	self.fog_controller._init_bag(self)
	self.resolution._init_bag(self)
	self.gamepad._init_bag(self)
	self.pandora._init_bag(self)

	self.processing._init_bag(self)
	self.processing.ready = true
	self.processing.register(self.camera)
	self.processing.register(self.gamepad)

	self.online_request._init_bag(self)
	self.online_request_async._init_bag(self)
	self.online_player._init_bag(self)
	self.online_maps._init_bag(self)
	self.online_multiplayer._init_bag(self)
	self.tileset_handler._init_bag(self)
	self.script_player._init_bag(self)
	self.game_conditions._init_bag(self)
	self.ai.pathfinder._init_bag(self)
	self.ai._init_bag(self)
	self.perform._init_bag(self)
	self.waypoint_factory._init_bag(self)

	self.storyteller._init_bag(self)

	if ProjectSettings.get_setting('tof/enable_save_load'):
		self.saving = load('res://scripts/saving.gd').new()
		self.saving._init_bag(self)



