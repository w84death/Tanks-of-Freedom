
extends Control

var map_file = File.new()
var hud_file
var hud_file_play_button
var hud_file_save_button
var hud_file_load_button
var hud_file_name

var map
var terrain
var units

const MAP_MAX_X = 64
const MAP_MAX_Y = 64

func init_gui():
	hud_file = self.get_node("top/file_card")
	hud_file_name = hud_file.get_node("name")
	hud_file_play_button = hud_file.get_node("play")
	hud_file_save_button = hud_file.get_node("save")
	hud_file_load_button = hud_file.get_node("load")
	hud_file_play_button.connect("pressed", self, "play_map")
	hud_file_save_button.connect("pressed", self, "save_map")
	hud_file_load_button.connect("pressed", self, "load_map")

	map = get_node("blueprint/center/scale/map")
	terrain = map.get_node("terrain")
	units = map.get_node("terrain/units")

func test_map():
	return

func save_map():
	var temp_data = []
	var temp_terrain = false
	var temp_unit = false
	
	for x in range(MAP_MAX_X):
		for y in range(MAP_MAX_Y):
			if terrain.get_cell(x,y) > -1:
				temp_terrain = terrain.get_cell(x,y)
			
			if units.get_cell(x,y) > -1:
				temp_unit = units.get_cell(x,y)
			
			if temp_terrain or temp_unit:
				temp_data.append({
					x=x,y=y,
					terrain=temp_terrain,
					unit=temp_unit
				})
			temp_terrain = false
			temp_unit = false
	
	if self.check_file_name(hud_file_name.get_text()):
		map_file.open("user://"+hud_file_name.get_text()+".tof",File.WRITE)
		map_file.store_var(temp_data)
		print('ToF: map saved to file')
	else:
		print('ToF: wrong file name')
	return

func check_file_name(name):
	# we need to check here for unusual charracters
	# and trim spaces, convert to lower case etc
	# allowed: [a-z] and "-"
	# and can not name 'settings' !!!
	if not name == "":
		return true
	else:
		return false

func load_map():
	var temp_data
	var cell
	
	if map_file.file_exists("user://"+hud_file_name.get_text()+".tof"):
		map_file.open("user://"+hud_file_name.get_text()+".tof",File.READ)
		temp_data = map_file.get_var()
		terrain.clear()
		units.clear()
		for cell in temp_data:
			if cell.terrain:
				terrain.set_cell(cell.x,cell.y,cell.terrain)
			if cell.unit:
				units.set_cell(cell.x,cell.y,cell.unit)
		units.raise()
		print('ToF: map loaded from file')
	else:
		print('ToF: map file not exists!')
	return

func _ready():
	init_gui()
	pass


