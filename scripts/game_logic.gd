extends Control

var selector
var selector_position
var current_map
var map_pos
var game_scale

var action_controller
var sound_controller

func _input(event):



	if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):
		game_scale = get_node("/root/game/pixel_scale").get_scale()
		map_pos = current_map.get_pos()
		selector_position = current_map.world_to_map( Vector2((event.x/game_scale.x)-map_pos.x,(event.y/game_scale.y)-map_pos.y))

	if (event.type == InputEvent.MOUSE_MOTION):
		var position = current_map.map_to_world(selector_position)
		position.y += 2
		selector.set_pos(position)

# MOUSE SELECT
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.pressed and event.button_index == BUTTON_LEFT):
			action_controller.handle_action(selector_position)
	
	if Input.is_action_pressed('ui_cancel'):
		action_controller.clear_active_field()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	selector = get_node('/root/game/pixel_scale/map/selector')
	current_map = get_node("/root/game/pixel_scale/map")
	game_scale = get_node("/root/game/pixel_scale").get_scale()
	action_controller = preload("action_controller.gd").new()
	
	sound_controller = preload("sound_controller.gd").new()
	sound_controller.init(get_node("/root/game/StreamPlayer"))
	sound_controller.play_soundtrack()
	
	action_controller.init_root(self)
	action_controller.switch_to_player(0)
	set_process_input(true)
	pass


