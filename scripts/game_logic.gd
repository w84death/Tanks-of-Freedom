extends Control

var selector
var selector_position
var current_map_terrain
var map_pos
var game_scale
var scale_root
var map_template = preload('res://maps/map_1.xscn')
var hud_template = preload('res://gui/gui.xscn')

var action_controller
var sound_controller

var current_map
var hud

var is_map_loaded = false

func _input(event):
	if is_map_loaded:
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

		if Input.is_action_pressed('ui_cancel'):
			action_controller.clear_active_field()

func load_map():
	current_map = map_template.instance()
	hud = hud_template.instance()
	
	selector = current_map.get_node('terrain/selector')
	current_map_terrain = current_map.get_node("terrain")
	scale_root = get_node("/root/game/pixel_scale")
	
	scale_root.add_child(current_map)
	self.add_child(hud)
	
	game_scale = scale_root.get_scale()
	action_controller = preload("action_controller.gd").new()

	sound_controller = preload("sound_controller.gd").new()
	sound_controller.init(get_node("/root/game/StreamPlayer"))
	sound_controller.play_soundtrack()

	var a_star = preload("a_star_pathfinding.gd").new()
	a_star._ready()

	action_controller.init_root(self, current_map, hud)
	action_controller.switch_to_player(0)
	set_process_input(true)

	is_map_loaded = true

func unload_map():
	is_map_loaded = false
	scale_root.remove_child(current_map)
	current_map.queue_free()
	current_map = null
	self.remove_child(hud)
	hud.queue_free()
	hud = null
	return

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	self.load_map()
	pass
