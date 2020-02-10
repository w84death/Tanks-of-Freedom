extends "res://scripts/migrations/abstract_version.gd"

var file_handler = File.new()
var list_file_path = "user://maps_list.tof"

func _init(bag).(bag):
	self.version = 20150730

var mapping = [
	[1, 0],
	[2, 1],
	[3, 2],
	[17, 3],
	[4, 4],
	[14, 5],
	[15, 6],
	[18, 8],
	[12, 9],
	[5, 10],
	[6, 11],
	[7, 12],
	[8, 13],
	[9, 14],
	[10, 15],
	[11, 16],
	[13, 17],
]

func migrate():
	for map in self.bag.map_list.maps:
		self.update_map(map)
	self.update_map('restore_map')

func update_map(name):
	var map_data
	if not self.file_handler.file_exists("user://" + name + ".tof"):
		return

	self.file_handler.open("user://" + name + ".tof", File.READ)
	map_data = self.file_handler.get_var()
	self.file_handler.close()
	map_data = self.update_data_array(map_data)
	self.file_handler.open("user://" + name + ".map", File.WRITE)
	self.file_handler.store_var(map_data)
	self.file_handler.close()

func update_data_array(data):
	var temp_data = []
	var new_cell
	for cell in data:
		for map in self.mapping:
			if map[0] == cell.terrain:
				new_cell = map[1]
		temp_data.append({
			x=cell.x,
			y=cell.y,
			terrain=new_cell,
			unit=cell.unit
		})
	return temp_data
