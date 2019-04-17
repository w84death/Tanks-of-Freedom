extends Node2D

var unit

func _die():
	unit.clear_explosion()

func clear_points():
	unit.clear_floating_damage()

func show_ap_icon():
	get_node('AP').show()
