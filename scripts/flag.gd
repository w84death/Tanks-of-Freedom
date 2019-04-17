extends Sprite

var anim
var animation_total_duration
export var color = 2

func change_flag(color_code):
	if color_code == 0:
		anim.play("blue")
	elif color_code == 1:
		anim.play("red")
	else:
		anim.play("white")
	anim.seek(randf() * animation_total_duration,true)

func _ready():
	anim = self.get_node("anim")
	animation_total_duration = anim.get_current_animation_length()
	change_flag(color)
	pass
	
