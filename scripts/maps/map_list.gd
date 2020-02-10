extends "res://scripts/bag_aware.gd"

var file_handler = File.new()
var maps = {}
var remote_maps = {}
var local_list_file_path = "user://maps_list.tof"
var remote_list_file_path = "user://remote_maps_list.tof"

var default_custom_maps = [
	{
		'name' : 'crossroad',
		'file' : preload('res://maps/custom/crossroad.gd').new()
	},
	{
		'name' : 'hearth_of_wild',
		'file' : preload('res://maps/custom/hearth_of_wild.gd').new()
	},
	{
		'name' : 'king_of_the_hill',
		'file' : preload('res://maps/custom/king_of_the_hill.gd').new()
	},

	{
		'name' : 'tof_duel1',
		'file' : preload('res://maps/custom/tof_dm1.gd').new()
	},
	{
		'name' : 'siege1',
		'file' : preload('res://maps/custom/zuo1.gd').new()
	},
	{
		'name' : 'siege2',
		'file' : preload('res://maps/custom/zuo2.gd').new()
	},
	{
		'name' : 'river_raid',
		'file' : preload('res://maps/custom/zuo3.gd').new()
	},
	{
		'name' : 'high_pressure',
		'file' : preload('res://maps/custom/zuo4.gd').new()
	},
	{
		'name' : 'a_maze',
		'file' : preload('res://maps/custom/zuo5.gd').new()
	},
	{
		'name' : 'developer_map',
		'file' : preload('res://maps/custom/developer_map.gd').new()
	},
	{
		'name' : 'split',
		'file' : preload('res://maps/custom/split.gd').new()
	},
	{
		'name' : 'territorial',
		'file' : preload('res://maps/custom/territorial.gd').new()
	},
	{
		'name' : 'gameplay_examples',
		'file' : preload('res://maps/custom/gameplay_examples.gd').new()
	},
]

func _initialize():
	if file_handler.file_exists(self.local_list_file_path):
		self.load_local_list()
	else:
		self.save_local_list()

	if file_handler.file_exists(self.remote_list_file_path):
		self.load_remote_list()
	else:
		self.save_remote_list()

	self.add_default_maps()

func load_list():
	self.load_local_list()
	self.load_remote_list()

func save_list():
	self.save_local_list()
	self.save_remote_list()

func load_local_list():
	self.file_handler.open(self.local_list_file_path, File.READ)
	self.maps = self.file_handler.get_var()
	self.file_handler.close()

func save_local_list():
	self.file_handler.open(self.local_list_file_path, File.WRITE)
	self.file_handler.store_var(self.maps)
	self.file_handler.close()

func load_remote_list():
	self.file_handler.open(self.remote_list_file_path, File.READ)
	self.remote_maps = self.file_handler.get_var()
	self.file_handler.close()

func save_remote_list():
	self.file_handler.open(self.remote_list_file_path, File.WRITE)
	self.file_handler.store_var(self.remote_maps)
	self.file_handler.close()

func add_map(map_name):
	self.maps[map_name] = {
		'name' : map_name,
		'completed' : false
	}

func store_map(map_name):
	self.add_map(map_name)
	self.save_local_list()

func add_default_maps():
	var file_name
	var map_data
	for map in self.default_custom_maps:
		file_name = 'user://' + map['name'] + '.map'
		if not file_handler.file_exists(file_name):
			self.file_handler.open(file_name, File.WRITE)
			map_data = {
				'tiles' : map['file'].map_data
			}
			self.file_handler.store_var(map_data)
			self.file_handler.close()
			self.store_map(map['name'])

func remove_map(name):
	self.maps.erase(name)
	self.save_local_list()

func store_remote_map(code, metadata):
	self.remote_maps[code] = metadata
	self.save_remote_list()

func remove_remote_map(code):
	self.remote_maps.erase(code)
	self.save_remote_list()

func get_local_map_data(map_name):
	var file_path = "user://" + map_name + ".map"
	return self.bag.file_handler.read(file_path)

func mark_map_win(map_name):
	self.maps[map_name]['completed'] = true
	self.save_local_list()

func has_remote_map(map_code):
	return self.remote_maps.has(map_code)
