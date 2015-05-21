var terrain_type
var position
var object = null
var damage = null
var abstract_map = null

var ant_parameters = [{'up':0,'down':0,'left':0,'right':0},{'up':0,'down':0,'left':0,'right':0}]
var destroyed_tile_template = preload("res://terrain/destroyed_tile.xscn")

func get_terrain_type():
	return terrain_type

func is_adjacent(field):
	var diff_x = self.position.x - field.position.x
	var diff_y = self.position.y - field.position.y
	if diff_x < 0:
		diff_x = -diff_x
	if diff_y < 0:
		diff_y = -diff_y
	if diff_x + diff_y == 1:
		return true
	return false

func add_damage(damage_layer):
	damage = destroyed_tile_template.instance()
	damage_layer.add_child(damage)
	var damage_position = abstract_map.tilemap.map_to_world(self.position)
	damage_position.y += 8
	damage.set_pos(damage_position)

	var damage_frames = damage.get_vframes() * damage.get_hframes()
	var damage_frame = randi() % damage_frames
	damage.set_frame(damage_frame)

func mark_trail(new_position, player):
	var dx = clamp(position.x - new_position.x, -1, 1)
	var parameters = ant_parameters[player]
	if dx != 0:
		if dx == -1:
			parameters['left'] = parameters['left'] + 1
		else:
			parameters['right'] = parameters['right'] + 1
	else:
		var dy = clamp(position.y - new_position.y, -1, 1)
		if dy == 1:
			parameters['down'] = parameters['down'] + 1
		else:
			parameters['up'] = parameters['up'] + 1

func next_tile_by_trail(directions):
	if directions.size() == 0:
		return null

	var next_tile = position
	var player = self.object.player
	var parameters = ant_parameters[player]
	var val = 0
	var direction_name = ''
	# TODO this directions can be not valid
	# print('AVAILABLE', directions)
	for direction in parameters:
		randomize()
		if directions.find(direction) > -1:
			if  parameters[direction] > val:
				val = parameters[direction]
			elif parameters[direction] == val && randf() > 0.3 : #we have two equals directions)
				val = parameters[direction]

			val = parameters[direction]
			direction_name = direction


	if direction_name == '':
		direction_name = directions[randi() % directions.size()]

	if direction_name == 'right':
		next_tile.x = next_tile.x + 1
	elif direction_name == 'left':
		next_tile.x = next_tile.x - 1
	elif direction_name == 'up':
		next_tile.y = next_tile.y - 1
	elif direction_name == 'down':
		next_tile.y = next_tile.y + 1

	print('!', direction_name)
	return next_tile

