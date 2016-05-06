extends "res://scripts/migrations/abstract_version.gd"

var file_handler = File.new()
var list_file_path = "user://maps_list.tof"
var maps_list

func _init(bag).(bag):
    self.version = 20160506

func migrate():
    var keys

    self.maps_list = self.load_map_list()
    keys = self.maps_list.keys()
    for map in keys:
        self.update_map(map)
    self.save_map_list()

func load_map_list():
    return self.bag.file_handler.read(self.list_file_path)

func save_map_list():
    self.bag.file_handler.write(self.list_file_path, self.maps_list)

func update_map(name):
    self.maps_list[name] = {
        'name' : name,
        'completed' : false
    }
