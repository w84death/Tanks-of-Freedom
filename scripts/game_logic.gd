extends Control

var player1
var click_position
var current_map
var map_pos
var game_scale
var units
var unit_selected = false

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_LEFT):
			map_pos = current_map.get_pos()
			click_position = current_map.world_to_map( Vector2((event.x/game_scale.x)-map_pos.x,(event.y/game_scale.y)-map_pos.y))
			print('click on map pos: ', click_position)
			
			if(not unit_selected):
				player1.set_pos((current_map.map_to_world(click_position)))
				for unit in units:
					if(unit.get_pos_map() == click_position):
						unit_selected = unit
						print('unit selected')
			else:
				unit_selected.set_pos(current_map.map_to_world(click_position))
				print('unit moved and unselect')
				unit_selected = false

#func _process(delta):
	# do realtime stuff here

func _ready():
	player1 = get_node('/root/game/pixel_scale/map/YSort/player_red')
	current_map = get_node("/root/game/pixel_scale/map")
	game_scale = get_node("/root/game/pixel_scale").get_scale()
	units = get_tree().get_nodes_in_group("units")
	set_process_input(true)
	#set_process(true)
	pass


