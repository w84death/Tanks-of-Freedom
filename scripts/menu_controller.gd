
var root

var map_0_button
var map_1_button
var map_2_button
var map_3_button
var close_button

func _ready():
	map_0_button = get_node("control/game_controls/map_0")
	map_1_button = get_node("control/game_controls/map_1")
	map_2_button = get_node("control/game_controls/map_2")
	map_3_button = get_node("control/game_controls/map_3")
	close_button = get_node("control/game_controls/close")
	
	map_0_button.connect("pressed", self, "load_small_map")
	map_1_button.connect("pressed", self, "load_large_map")
	close_button.connect("pressed", root, "toggle_menu")

func load_small_map():
	root.load_map(root.map_template_0)
	root.toggle_menu()

func load_large_map():
	root.load_map(root.map_template_1)
	root.toggle_menu()

func init_root(root_node):
	root = root_node
