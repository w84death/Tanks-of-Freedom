
var root

var small_map_button
var large_map_button

var close_button

func _ready():
	small_map_button = get_node("control/small")
	large_map_button = get_node("control/large")
	close_button = get_node("control/x")
	
	small_map_button.connect("pressed", self, "load_small_map")
	large_map_button.connect("pressed", self, "load_large_map")
	close_button.connect("pressed", root, "toggle_menu")
	
func load_small_map():
	root.load_map(root.map_template_0)
	root.toggle_menu()

func load_large_map():
	root.load_map(root.map_template_1)
	root.toggle_menu()

func init_root(root_node):
	root = root_node
