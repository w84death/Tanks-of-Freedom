
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"
var animation
var wave_pos

func _ready():
	animation = self.get_node('anim')
	wave_pos = (1+ sin(self.get_pos().x) ) * ( animation.get_current_animation_length() * 0.5)
	animation.seek(wave_pos,true)
	pass


