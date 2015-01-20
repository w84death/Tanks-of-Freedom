
extends Camera2D
export var camera_zoom_level = Vector2(0.5,0.5)
export var camera_position = Vector2(0,0)
const CAMERA_SPEED = 100
const CAMERA_ZOOM_STEPS = 0.05

func _fixed_process(delta):
	
	if (Input.is_action_pressed('camera_in')):
		if(camera_zoom_level>Vector2(0.25,0.25)):
			camera_zoom_level-=Vector2(CAMERA_ZOOM_STEPS,CAMERA_ZOOM_STEPS)
			
	if (Input.is_action_pressed('camera_out')):
		if(camera_zoom_level<Vector2(1,1)):
			camera_zoom_level+=Vector2(CAMERA_ZOOM_STEPS,CAMERA_ZOOM_STEPS)
		
#	set_zoom(camera_zoom_level)
	
	if (Input.is_action_pressed('camera_left')):
		camera_position-=Vector2(CAMERA_SPEED*delta,0)
		
	if (Input.is_action_pressed('camera_right')):
		camera_position+=Vector2(CAMERA_SPEED*delta,0)
		
	if (Input.is_action_pressed('camera_up')):
		camera_position-=Vector2(0,CAMERA_SPEED*delta)
		
	if (Input.is_action_pressed('camera_down')):
		camera_position+=Vector2(0,CAMERA_SPEED*delta)
		
	set_pos(camera_position)
	print(camera_position)

func _ready():
	set_fixed_process(true)
	pass
