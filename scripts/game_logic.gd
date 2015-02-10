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

var current_map
var hud

var maps = {
	'tutorial' : preload('res://maps/map_0.xscn'),
	'crossing' : preload('res://maps/map_0.xscn'),
	'city' : preload('res://maps/map_1.xscn'),
	'forest' : preload('res://maps/map_2.xscn')
}

var sound_settings = {
	'sound_enabled' : true,
	'music_enabled' : true
}

var is_map_loaded = false
var is_intro = true
var is_paused = false

func _input(event):
	if is_intro:
		self.load_menu()

	if is_map_loaded && is_paused == false:
		if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):

			game_scale = get_node("/root/game/pixel_scale").get_scale()
			map_pos = current_map_terrain.get_pos()

			selector_position = current_map_terrain.world_to_map( Vector2((event.x/game_scale.x)-map_pos.x,(event.y/game_scale.y)-map_pos.y))
		if (event.type == InputEvent.MOUSE_MOTION):
			var position = current_map_terrain.map_to_world(selector_position)
			position.y += 2
			selector.set_pos(position)

		# MOUSE SELECT
		if (event.type == InputEvent.MOUSE_BUTTON):
			if (event.pressed and event.button_index == BUTTON_LEFT):
				action_controller.handle_action(selector_position)
				action_controller.post_handle_action()

		if (event.type == InputEvent.KEY):
			action_controller.perform_ai_stuff()

	if Input.is_action_pressed('ui_cancel'):
		self.toggle_menu()

func load_map(template_name):
	self.unload_map()
	map_template = maps[template_name]
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
	menu.close_button.show()
	is_map_loaded = true
	set_process_input(true)

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
	menu.close_button.hide()
	return
	
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
			
func load_menu():
	is_intro = false
	self.add_child(menu)
	menu.close_button.hide()
	cursor.show()
	cursor.raise()
	self.remove_child(intro)
	intro.queue_free()
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	scale_root = get_node("/root/game/pixel_scale")
	sound_controller.init_root(self)
	menu.init_root(self)
	cursor.hide()
	self.add_child(cursor)
	self.add_child(intro)
	pass
