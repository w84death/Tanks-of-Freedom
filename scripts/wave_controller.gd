extends Sprite

var animation
var wave_pos
var root
var angle_line
var animation_length

func _ready():
	root = get_node("/root/game")
	animation = self.get_node('anim')
	angle_line = int(self.get_pos().x)
	if root.current_map_terrain != null:
		angle_line = root.current_map_terrain.world_to_map(self.get_pos())
		angle_line = int(angle_line.y)
	#wave_pos = (1+ sin(angle_line) ) * ( animation.get_current_animation_length() * 0.5)
	animation_length = int(animation.get_current_animation_length())
	wave_pos = angle_line % animation_length
	animation.play('wave_' + str(randi()%3) )
	animation.seek(wave_pos,true)
