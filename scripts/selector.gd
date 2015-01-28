
extends AnimatedSprite

var anim

func set_player(player):
	if player == 0:
		anim.play("blue")
	if player == 1:
		anim.play("red")

func set_neutral():
	anim.play("neutral")

func _ready():
	anim = self.get_node("anim")
	anim.play("neutral")
	pass


