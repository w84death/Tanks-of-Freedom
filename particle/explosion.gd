extends Sprite

var unit

func _die(var _empty_anim : String):
	unit.clear_explosion()

func clear_points(var _empty_anim : String):
	unit.clear_floating_damage()

func show_ap_icon():
	get_node('AP').show()
