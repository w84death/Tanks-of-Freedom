func move_object(active_field, field):
	var from = active_field
	var to = field
	
	if (self.is_possible(to)):
		to.object = from.object
		from.object = null
		to.object.set_pos_map(to.position)
	
func is_possible(to):
	print(to.terrain_type)
	print('checking movement')
	return true
	
func handle_action_points():
	print('action points')