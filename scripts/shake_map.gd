# TODO - this class is under development

# var shake_timer = Timer.new()
# var shakes = 0
# export var shakes_max = 5
# export var shake_time = 0.25
# export var shake_boundary = 5
# var shake_initial_position
#
# func shake_camera():
# 	if root.settings['shake_enabled'] and not mouse_dragging:
# 		shakes = 0
# 		shake_initial_position = terrain.get_pos()
# 		self.do_single_shake()
#
# func do_single_shake():
# 	if shakes < shakes_max:
# 		var direction_x = randf()
# 		var direction_y = randf()
# 		var distance_x = randi() % shake_boundary
# 		var distance_y = randi() % shake_boundary
# 		if direction_x <= 0.5:
# 			distance_x = -distance_x
# 		if direction_y <= 0.5:
# 			distance_y = -distance_y
#
# 		pos = Vector2(shake_initial_position) + Vector2(distance_x, distance_y)
# 		target = pos
# 		underground.set_pos(pos)
# 		terrain.set_pos(pos)
# 		shakes += 1
# 		shake_timer.start()
# 	else:
# 		pos = shake_initial_position
# 		target = pos
# 		underground.set_pos(shake_initial_position)
# 		terrain.set_pos(shake_initial_position)