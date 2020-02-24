
var size = Vector2(0, 0)
var fields = [[null]]
var map
var tilemap
var field_template = load('res://scripts/abstract_field.gd')

var MAX_MAP_SIZE = 40
const MAP_MAX_X = 40
const MAP_MAX_Y = 40

func reset():
	self.size = Vector2(0, 0)
	self.fields = [[null]]

func init_map(map_node):
	self.map = map_node
	self.tilemap = self.map.get_node("terrain")

func get_fields():
	return fields

# TODO extending should be done in diferent wa
func get_field(positionVAR):
	if positionVAR.x < 0 || positionVAR.y < 0:
		return self.create_out_of_bounds_field()

	if fields[0][0] == null:
		fields[0][0] = self.create_field(Vector2(0, 0))

	if (positionVAR.x > size.x || positionVAR.y > size.y):
		self.extend(positionVAR)
	return fields[positionVAR.y][positionVAR.x]

func extend(positionVAR):
	var row
	var field
	#extend existing rows
	for i in range(size.y + 1):
		row = fields[i]
		for j in range(positionVAR.x - size.x):
			row.insert(size.x + j + 1, self.create_field(Vector2(size.x + j + 1, i)))

	#add new rows
	var width = positionVAR.x
	if size.x > width:
		width = size.x

	for i in range(positionVAR.y - size.y):
		row = []
		for j in range(width + 1):
			row.insert(j, self.create_field(Vector2(j, size.y + i + 1)))
		fields.insert(size.y + i + 1, row)

	if positionVAR.x > size.x:
		size.x = positionVAR.x
	if positionVAR.y > size.y:
		size.y = positionVAR.y

func create_field(positionVAR):
	var field = field_template.new()
	field.positionVAR = positionVAR
	field.terrain_type = tilemap.get_cell(positionVAR.x, positionVAR.y)
	field.abstract_map = self
	return field

func is_spawning_point(positionVAR):
	return tilemap.get_cell(positionVAR.x, positionVAR.y) == 13


func create_out_of_bounds_field():
	var field = self.create_field(Vector2(-1, -1))

	return field


