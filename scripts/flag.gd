
extends Sprite

var anim
var RANDOM_MAX
export var color = 2

func change_flag(color_code):
	if color_code == 0:
		anim.play("blue")
	elif color_code == 1:
		anim.play("red")
	else:
		anim.play("white")
	anim.seek(randi(),true)

func _ready():
	anim = self.get_node("anim")
	RANDOM_MAX = anim.get_current_animation_length()
	change_flag(color)
	pass
	