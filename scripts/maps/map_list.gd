
var file_handler = File.new()
var maps = {}
var list_file_path = "user://maps_list.tof"

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
]

func _init():
    if file_handler.file_exists(self.list_file_path):
        self.load_list()
    else:
        self.save_list()
    self.add_default_maps()

func load_list():
    self.file_handler.open(self.list_file_path, File.READ)
    self.maps = self.file_handler.get_var()
    self.file_handler.close()

func save_list():
    self.file_handler.open(self.list_file_path, File.WRITE)
    self.file_handler.store_var(self.maps)
    self.file_handler.close()

func add_map(map_name):
    self.maps[map_name] = map_name

func store_map(map_name):
    self.add_map(map_name)
    self.save_list()

func add_default_maps():
    var file_name
    for map in self.default_custom_maps:
        file_name = 'user://' + map['name'] + '.map'
        if not file_handler.file_exists(file_name):
            self.file_handler.open(file_name, File.WRITE)
            self.file_handler.store_var(map['file'].map_data)
            self.file_handler.close()
            self.store_map(map['name'])

func remove_map(name):
    self.maps.erase(name)
    self.save_list()
