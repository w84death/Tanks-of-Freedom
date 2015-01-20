
extends AnimatedSprite

# member variables here, example:
# var a=2
# var b="textvar"
var frame = 0
var x = 0

func _fixed_process(delta):
	set_frame(frame)
	x += 1
	if ( x < 120 ):
		frame += 1
	else:
		x = 0
		
	if(frame>get_sprite_frames().get_frame_count( ) ):
		frame = 0

func _ready():
	# Initalization here
	set_fixed_process(true)
	pass


