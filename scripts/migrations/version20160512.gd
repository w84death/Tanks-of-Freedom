extends "res://scripts/migrations/abstract_version.gd"

var file_handler = File.new()
var list_file_path = "user://maps_list.tof"

func _init(bag).(bag):
    self.version = 20160512

func migrate():
    self.file_handler.open(self.list_file_path, File.READ)
    var map_list = self.file_handler.get_var()
    self.file_handler.close()
    for map in map_list:
        self.update_map(map)
    self.update_map('restore_map')

func update_map(name):
    var map_data
    if not self.file_handler.file_exists("user://" + name + ".map"):
        return

    self.file_handler.open("user://" + name + ".map", File.READ)
    map_data = self.file_handler.get_var()
    self.file_handler.close()
    map_data = self.update_data_array(map_data)
    self.file_handler.open("user://" + name + ".map", File.WRITE)
    self.file_handler.store_var(map_data)
    self.file_handler.close()

func update_data_array(data):
    return {
        'tiles' : data
    }
