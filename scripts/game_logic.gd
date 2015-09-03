extends Control

var version_name = "Version 0.3.7-BETA"

var selector = preload('res://gui/selector.xscn').instance()
var selector_position
var current_map_terrain
var map_pos
var game_scale
var scale_root
var hud_template = preload('res://gui/gui.xscn')
var menu

var intro = preload('res://intro.xscn').instance()

var action_controller
var sound_controller = preload("sound_controller.gd").new()
var hud_controller
var current_map
var current_map_name
var hud
var ai_timer

var dependency_container = preload('res://scripts/dependency_container.gd').new()

var map_template = preload('res://maps/workshop.xscn')
var main_tileset = preload("res://maps/map_tileset.xml")

var settings = {
	'is_ok' : true,
	'sound_enabled' : true,
	'music_enabled' : true,
	'shake_enabled' : true,
	'cpu_0' : false,
	'cpu_1' : true,
	'turns_cap': 0,
	'camera_follow': true,
	'music_volume': 0.5,
	'sound_volume': 0.2
}

var is_map_loaded = false
var is_intro = true
var is_demo = false
var is_paused = false
var is_locked_for_cpu = false
var is_from_workshop = false
var settings_file = File.new()
var workshop_file_name

func _input(event):
	if is_demo == true:
		is_demo = false
		get_node("DemoTimer").stop()

	if is_map_loaded && is_paused == false:
		if is_locked_for_cpu == false:
			if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):

				game_scale = scale_root.get_scale()
				map_pos = current_map_terrain.get_pos()

				selector_position = current_map_terrain.world_to_map( Vector2((event.x/game_scale.x)-map_pos.x,(event.y/game_scale.y)-map_pos.y))
			if (event.type == InputEvent.MOUSE_MOTION):
				var position = current_map_terrain.map_to_world(selector_position)
				position.y += 2
				selector.set_pos(position)
				#selector.calculate_cost()

			# MOUSE SELECT
			if (event.type == InputEvent.MOUSE_BUTTON):
				if (event.pressed and event.button_index == BUTTON_LEFT):

					if not self.dependency_container.hud_dead_zone.is_dead_zone(event.x, event.y):
						var position = current_map_terrain.map_to_world(selector_position)
						if not self.dependency_container.hud_dead_zone.is_dead_zone(position.x, position.y):
							action_controller.handle_action(selector_position)
							action_controller.post_handle_action()

		if event.type == InputEvent.KEY && event.scancode == KEY_H && event.pressed:
			if hud.is_visible():
				hud.hide()
			else:
				hud.show()

	if Input.is_action_pressed('ui_cancel') && (event.type != InputEvent.KEY || not event.is_echo()):
		self.toggle_menu()

func start_ai_timer():
	ai_timer.reset_state()
	ai_timer.inject_action_controller(action_controller, hud_controller)
	ai_timer.start()

func load_map(template_name, workshop_file_name = false):
	var human_player = 'cpu_0'
	self.unload_map()
	self.menu.hide_background_map()
	current_map_name = template_name
	current_map = map_template.instance()
	current_map.get_node('terrain').set_tileset(self.main_tileset)
	current_map.campaign = dependency_container.campaign
	self.workshop_file_name = workshop_file_name
	if workshop_file_name:
		self.is_from_workshop = true
		current_map.load_map(workshop_file_name)
	else:
		human_player = 'cpu_' + str(self.dependency_container.campaign.get_map_player(template_name))
		self.is_from_workshop = false
		self.settings['cpu_0'] = true
		self.settings['cpu_1'] = true
		self.settings[human_player] = false
		current_map.load_campaign_map(template_name)
	current_map.show_blueprint = false
	hud = hud_template.instance()

	current_map_terrain = current_map.get_node("terrain")
	current_map_terrain.add_child(selector)

	scale_root.add_child(current_map)
	menu.raise()
	self.add_child(hud)

	game_scale = scale_root.get_scale()
	action_controller = self.dependency_container.controllers.action_controller
	action_controller.init_root(self, current_map, hud)
	hud_controller = action_controller.hud_controller
	if workshop_file_name:
		action_controller.switch_to_player(0)
		self.dependency_container.match_state.reset()
	else:
		action_controller.switch_to_player(self.dependency_container.campaign.get_map_player(template_name))
		self.dependency_container.match_state.set_campaign_map(template_name)
	hud_controller.show_map()
	selector.init(self)
	if (menu && menu.close_button):
		menu.close_button.show()
	is_map_loaded = true
	set_process_input(true)

	if settings[human_player]:
		self.lock_for_cpu()
	else:
		self.unlock_for_player()
	sound_controller.play_soundtrack()

func restart_map():
	self.load_map(current_map_name,workshop_file_name)

func unload_map():
	if is_map_loaded == false:
		return

	is_map_loaded = false
	current_map_terrain.remove_child(selector)
	scale_root.remove_child(current_map)
	current_map.queue_free()
	current_map = null
	current_map_terrain = null
	self.hud_controller.detach_hud_panel()
	self.remove_child(hud)
	hud.queue_free()
	hud = null
	selector.reset()
	menu.close_button.hide()
	ai_timer.reset_state()
	hud_controller = null
	action_controller = null
	self.menu.show_background_map()

func toggle_menu():
	if is_map_loaded:
		if menu.is_hidden():
			is_paused = true
			action_controller.stats_set_time()
			menu.show()
			hud.hide()
		else:
			is_paused = false
			action_controller.stats_start_time()
			menu.hide()
			hud.show()

func show_missions():
	self.toggle_menu()
	menu.show_maps_menu()

func show_campaign():
	self.toggle_menu()
	self.dependency_container.controllers.campaign_menu_controller.show_campaign_menu()

func load_menu():
	menu.show()
	is_intro = false
	self.remove_child(intro)
	intro.queue_free()
	self.add_child(menu)
	menu.close_button.hide()

func lock_for_cpu():
	self.is_locked_for_cpu = true
	self.hud_controller.lock_hud()
	self.selector.hide()
	if self.settings['cpu_0'] * self.settings['cpu_1'] == 0:
		self.current_map.camera_follow = false
		self.hud_controller.show_cinematic_camera()
	else:
		self.hud_controller.hide_cinematic_camera()

func unlock_for_player():
	self.is_locked_for_cpu = false
	self.hud_controller.unlock_hud()
	self.selector.show()
	self.current_map.camera_follow = true
	self.hud_controller.hide_cinematic_camera()

func lock_for_demo():
	is_demo = true
	self.lock_for_cpu()

func unlock_for_demo():
 	is_demo = false

func read_settings_from_file():
	var check
	if settings_file.file_exists("user://settings.tof"):
		settings_file.open("user://settings.tof",File.READ)
		check = settings_file.get_var()
		if self.check_file_data(check):
			for option in check:
				self.settings[option] = check[option]
			#print('ToF: settings loaded from file')
		else:
			#print('ToF: filecheck filed! making new file with default settings')
			self.write_settings_to_file()
		settings_file.close()
	else:
		self.write_settings_to_file()
	return

func check_file_data(data):
	if str(data) and data.has('is_ok'):
		return true
	else:
		return false

func write_settings_to_file():
	settings_file.open("user://settings.tof",File.WRITE)
	settings_file.store_var(self.settings)
	#print('ToF: settings saved to file')
	settings_file.close()
	return

func _ready():
	scale_root = get_node("/root/game/pixel_scale")
	self.ai_timer = get_node("AITimer")
	self.dependency_container.init_root(self)
	self.read_settings_from_file()
	self.menu = self.dependency_container.controllers.menu_controller
	sound_controller.init_root(self)
	menu.init_root(self)
	menu.hide()
	intro.init_root(self)
	self.add_child(intro)
	pass
