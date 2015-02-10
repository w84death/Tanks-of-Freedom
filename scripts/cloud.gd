
extends AnimatedSprite

var anim

func _ready():
	anim = self.get_node("anim")
	anim.play("warning")
	pass


