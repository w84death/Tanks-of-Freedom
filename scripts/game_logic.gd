extends Control

var selector
var selector_position
var current_map
var map_pos
var game_scale
var units
var unit_selected = false
var abstract_map

func _input(event):
# UPDATE LIVE STUFF
	if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):
		units = get_tree().get_nodes_in_group("units")
		map_pos = current_map.get_pos()
		selector_position = current_map.world_to_map( Vector2((event.x/game_scale.x)-map_pos.x,(event.y/game_scale.y)-map_pos.y))

# MOUSE MOVE
	if (event.type == InputEvent.MOUSE_MOTION):
		var position = current_map.map_to_world(selector_position)
		position.y += 2
		selector.set_pos(position)

# MOUSE SELECT
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.pressed and event.button_index == BUTTON_LEFT):
			print('click on map pos: ', selector_position)
			if(not unit_selected):
				for unit in units:
					if(unit.get_pos_map() == selector_position):
						unit_selected = unit
						print('unit selected')
			else:
				unit_selected.set_pos_map(selector_position)
				print('unit moved and unselect')
				unit_selected = false
			
			var field = abstract_map.get_field(selector_position)
			if field == null:
				print('out of bounds')
			else:
				print(field.terrain_type)
				print(field.position)
		if (event.pressed and event.button_index == BUTTON_RIGHT):
			print('unit unselect')
			unit_selected = false

#func _process(delta):
	# do realtime stuff here

func _ready():
	selector = get_node('/root/game/pixel_scale/map/YSort/player_red')
	current_map = get_node("/root/game/pixel_scale/map")
	game_scale = get_node("/root/game/pixel_scale").get_scale()
	abstract_map = preload("abstract_map.gd").new()
	abstract_map.tilemap = current_map
	set_process_input(true)
	#set_process(true)
	pass


