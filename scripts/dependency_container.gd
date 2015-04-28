
var root

var map_list = preload("res://scripts/maps/map_list.gd").new()

func init_root(root_node):
    self.root = root_node

    map_list.init()