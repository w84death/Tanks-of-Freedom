
extends Control

const CAMERA_SPEED = 200
export var map_position = Vector2(0,0)

func _fixed_process(delta):
	if (Input.is_action_pressed('camera_left')):
		map_position+=Vector2(CAMERA_SPEED*delta,0)
		
	if (Input.is_action_pressed('camera_right')):
		map_position-=Vector2(CAMERA_SPEED*delta,0)
		
	if (Input.is_action_pressed('camera_up')):
		map_position+=Vector2(0,CAMERA_SPEED*delta)
		
	if (Input.is_action_pressed('camera_down')):
		map_position-=Vector2(0,CAMERA_SPEED*delta)
		
	get_node('test_map').set_pos(map_position)
	
func _ready():
	set_fixed_process(true)
	pass


