
var size = Vector2(0, 0)
var fields = [[null]]
var map
var tilemap
var field_template = preload('abstract_field.gd')
var movement_controller = preload('movement_controller.gd').new()
var cost_map = [[null]]
const nonwalkable_cost = 999

func get_fields():
	return fields

# TODO extending should be done in diferent wa
func get_field(position):
	if position.x < 0 || position.y < 0:
		return self.create_field(Vector2(-1, -1))

	if fields[0][0] == null:
		fields[0][0] = self.create_field(Vector2(0, 0))

	if (position.x > size.x || position.y > size.y):
		self.extend(position)
	return fields[position.y][position.x]

func extend(position):
	var row
	var field
	#extend existing rows
	for i in range(size.y + 1):
		row = fields[i]
		for j in range(position.x - size.x):
			row.insert(size.x + j + 1, self.create_field(Vector2(size.x + j + 1, i)))

	#add new rows
	var width = position.x
	if size.x > width:
		width = size.x

	for i in range(position.y - size.y):
		row = []
		for j in range(width + 1):
			row.insert(j, self.create_field(Vector2(j, size.y + i + 1)))
		fields.insert(size.y + i + 1, row)

	if position.x > size.x:
		size.x = position.x
	if position.y > size.y:
		size.y = position.y

func create_field(position):
	var field = field_template.new()
	field.position = position
	field.terrain_type = tilemap.get_cell(position.x, position.y)
	field.abstract_map = self
	return field

func is_spawning_point(position):
	return tilemap.get_cell(position.x, position.y) == 13

func create_tile_type_map():
	var row
	self.cost_map = []
	for x in range(32):
		row = []
		for y in range(32):
			var type = self.get_field(Vector2(x, y)).get_terrain_type()
			if (type == -1):
				row.insert(y, self.nonwalkable_cost)
			else:
				row.insert(y, 1)
		self.cost_map.insert(x, row)

func calculate_path_cost(unit, path):
	#start element
	var cost = 0
	var skip = true
	for pos in path:
		if !skip:
			if self.cost_map[pos.x][pos.y]:
				cost = cost + self.cost_map[pos.x][pos.y]
		skip = false

	return cost

func add_trails(paths, player, value=1):
	var count
	var pos
	for path in paths:
		count = path.size() - 1
		for idx in range(0, count):
			pos = path[idx]

			fields[pos.y][pos.x].mark_trail(path[idx + 1], 0)

func get_available_directions(unit, current_position):
	var directions = []
	var next_position

	next_position = __get_next_position(current_position, 1, 0)
	if self.__check_direction_avaibility(next_position) && !unit.check_hiccup(next_position):
		directions.append('right')

	next_position = __get_next_position(current_position, -1, 0)
	if self.__check_direction_avaibility(next_position) && !unit.check_hiccup(next_position):
		directions.append('left')

	next_position = __get_next_position(current_position, 0, -1)
	if self.__check_direction_avaibility(next_position) && !unit.check_hiccup(next_position):
		directions.append('up')

	next_position = __get_next_position(current_position, 0, 1)
	if self.__check_direction_avaibility(next_position) && !unit.check_hiccup(next_position):
		directions.append('down')

	return directions

func __get_next_position(current_position, x_mod, y_mod):
	var tmp = current_position
	tmp.x = tmp.x + x_mod
	tmp.y = tmp.y + y_mod

	return tmp

func __check_direction_avaibility(next_position):
	# we can assume that if building can be catchable it will be handled by standard ai

	if next_position.x < 0 || next_position.y < 0:
		return false

	var field = get_field(next_position)
	#print('position check', next_position)
	if field.terrain_type != - 1 && field.object == null:
		return true

	return false




