 extends Control

var selector = preload('res://gui/selector.xscn').instance()
var selector_position
var current_map_terrain
var map_pos
var game_scale
var scale_root
var hud_template = preload('res://gui/gui.xscn')
var menu = preload('res://gui/menu.xscn').instance()
var cursor = preload('res://gui/cursor.xscn').instance()

var intro = preload('res://intro.xscn').instance()

var action_controller
var sound_controller = preload("sound_controller.gd").new()
var hud_controller
var map_template
var current_map
var current_map_name
var hud
var ai_timer

var maps = {
	'map_1' : preload('res://maps/map_1.xscn'),
	'map_2' : preload('res://maps/map_1.xscn'),
	'map_3' : preload('res://maps/map_1.xscn'),
	'map_4' : preload('res://maps/map_1.xscn'),
	'map_5' : preload('res://maps/map_1.xscn'),
	'map_6' : preload('res://maps/map_1.xscn')
}

var settings = {
	'sound_enabled' : true,
	'music_enabled' : true,
	'shake_enabled' : true,
	'cpu_0' : false,
	'cpu_1' : true,
	'turns_cap': 0 #0==off
}

var is_map_loaded = false
var is_intro = true
var is_paused = false
var is_locked_for_cpu = false
var settings_file = File.new()

func _input(event):
	if is_intro:
		self.load_menu()

	if is_map_loaded && is_paused == false && is_locked_for_cpu == false:
		if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):

			game_scale = scale_root.get_scale()
			map_pos = current_map_terrain.get_pos()

			selector_position = current_map_terrain.world_to_map( Vector2((event.x/game_scale.x)-map_pos.x,(event.y/game_scale.y)-map_pos.y))
		if (event.type == InputEvent.MOUSE_MOTION):
			var position = current_map_terrain.map_to_world(selector_position)
			position.y += 2
			selector.set_pos(position)
			selector.calculate_cost()
			if not settings['cpu_' + str(action_controller.current_player)]:
				hud_controller.mark_potential_ap_usage(action_controller.active_field, selector.current_cost)

		# MOUSE SELECT
		if (event.type == InputEvent.MOUSE_BUTTON):
			if (event.pressed and event.button_index == BUTTON_LEFT):
				action_controller.handle_action(selector_position)
				action_controller.post_handle_action()
		
		if event.type == InputEvent.KEY && event.scancode == KEY_H && event.pressed:
			if hud.is_visible():
				hud.hide()
			else:
				hud.show()

	if Input.is_action_pressed('ui_cancel'):
		self.toggle_menu()

func start_ai_timer():
	ai_timer.reset_state()
	ai_timer.inject_action_controller(action_controller, hud_controller)
	ai_timer.start()

func load_map(template_name):
	self.unload_map()
	current_map_name = template_name
	var map_template = maps[template_name]
	current_map = map_template.instance()
	hud = hud_template.instance()

	current_map_terrain = current_map.get_node("terrain")
	current_map_terrain.add_child(selector)

	scale_root.add_child(current_map)
	menu.raise()
	self.add_child(hud)
	cursor.raise()

	game_scale = scale_root.get_scale()
	action_controller = preload("action_controller.gd").new()
	action_controller.init_root(self, current_map, hud)
	action_controller.switch_to_player(0)
	hud_controller = action_controller.hud_controller
	selector.init(action_controller)
	menu.close_button.show()
	is_map_loaded = true
	set_process_input(true)
	if settings['cpu_0']:
		self.lock_for_cpu()
	else:
		self.unlock_for_player()
	sound_controller.play_soundtrack()
	
func restart_map():
	self.load_map(current_map_name)

func unload_map():
	if is_map_loaded == false:
		return

	is_map_loaded = false
	current_map_terrain.remove_child(selector)
	scale_root.remove_child(current_map)
	current_map.queue_free()
	current_map = null
	current_map_terrain = null
	self.remove_child(hud)
	hud.queue_free()
	hud = null
	selector.reset()
	menu.close_button.hide()
	ai_timer.reset_state()
	hud_controller = null
	action_controller = null

func toggle_menu():
	if is_map_loaded:
		if menu.is_hidden():
			is_paused = true
			menu.show()
			hud.hide()
		else:
			is_paused = false
			menu.hide()
			hud.show()
			
func show_missions():
	self.toggle_menu()
	menu.show_maps_menu()

func load_menu():
	is_intro = false
	self.add_child(menu)
	menu.close_button.hide()
	cursor.show()
	cursor.raise()
	self.remove_child(intro)
	intro.queue_free()

func lock_for_cpu():
	is_locked_for_cpu = true
	hud.get_node("top_center/turn_card/end_turn").set_disabled(true)
	hud.get_node("top_center/turn_card/end_turn_red").set_disabled(true)
	selector.hide()
	
func unlock_for_player():
	is_locked_for_cpu = false
	hud.get_node("top_center/turn_card/end_turn").set_disabled(false)
	hud.get_node("top_center/turn_card/end_turn_red").set_disabled(false)
	selector.show()

func read_settings_from_file():
	if settings_file.file_exists("user://settings.tof"):
		settings_file.open("user://settings.tof",File.READ)
		self.settings = settings_file.get_var()
		print('ToF: settings loaded from file')
	else:
		self.write_settings_to_file()
	return

func write_settings_to_file():
	settings_file.open("user://settings.tof",File.WRITE)
	settings_file.store_var(self.settings)
	print('ToF: settings saved to file')
	return
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	self.read_settings_from_file()
	scale_root = get_node("/root/game/pixel_scale")
	ai_timer = get_node("AITimer")
	sound_controller.init_root(self)
	menu.init_root(self)
	cursor.hide()
	self.add_child(cursor)
	self.add_child(intro)
	pass
