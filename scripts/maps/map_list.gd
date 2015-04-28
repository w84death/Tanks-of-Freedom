
var list_file = File.new()
var maps = {}
var list_file_path = "user://maps_list.tof"

func init():
    if list_file.file_exists(self.list_file_path):
        self.load_list()
    else:
        self.init_list()

func init_list():
    self.list_file.open(self.list_file_path, File.WRITE)
    self.list_file.store_var(self.maps)
    self.list_file.close()

func load_list():
    return

func save_list():
    return

func add_map(map_name):
    self.maps[map_name] = map_name