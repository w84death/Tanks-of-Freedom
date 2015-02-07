
var size = Vector2(0, 0)
var fields = [[null]]
var tilemap
var field_template = preload('abstract_field.gd')
var movement_controller = preload('movement_controller.gd').new()
var tiles_cost_map = [[[null]]]
const unmovable_cost = 100

func get_fields():
	return fields

func get_field(position):
	if position.x < 0 || position.y < 0:
		return self.create_field(Vector2(-1, -1))

	if fields[0][0] == null:
		fields[0][0] = self.create_field(Vector2(0, 0))

	if (position.x > size.x || position.y > size.y):
		self.extend(position)
	var field = fields[position.y][position.x]
	return field

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
	return field

# for pathfinding
func create_tile_type_maps():
	self.create_tile_type_map_for_unit(preload('units/soldier.gd').new())
	self.create_tile_type_map_for_unit(preload('units/tank.gd').new())
	self.create_tile_type_map_for_unit(preload('units/helicopter.gd').new())

func create_tile_type_map_for_unit(unit):
	var stats = unit.get_stats();

	var row
	var tiles_type = []
	for x in range(size.x):
		row = []
		for y in range(size.y):
			var type = fields[y][x].get_terrain_type()
			if (type == -1):
				row.insert(y, unmovable_cost)
			else:
				row.insert(y,self.calculate_cost(stats, type))
		tiles_type.insert(x, row)
	tiles_cost_map.insert(unit.get_type(), tiles_type)
	print('map cost generate')

func calculate_cost(stats, type):
	var tile_type_name = movement_controller.get_type_name(type)
	return stats[tile_type_name]




