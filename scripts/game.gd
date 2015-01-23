extends Control

var player1 = get_node('player_red')
var current_map = get_node("map")
var map_pos
var game_scale
var units


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		#print( 'mouse over: ',current_map.world_to_map( Vector2((event.x/game_scale)-map_pos.x,(event.y/game_scale)-map_pos.y)))

#func _process(delta):
	# do realtime stuff here

func _ready():
	print('>',get_node("map"))
	units = get_tree().get_nodes_in_group("units")
	game_scale = get_node('pixel_scale').get_scale()
	#map_pos = current_map.get_pos()
	units = get_tree().get_nodes_in_group("units")
	set_process_input(true)
	#set_process(true)
	pass


