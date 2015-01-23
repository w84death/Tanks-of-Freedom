
extends AnimatedSprite
export var position_on_map = Vector2(0,0)

func get_pos_map():
	return position_on_map

func _ready():
	add_to_group("units")
	get_node('anim').play("move")
	pass


