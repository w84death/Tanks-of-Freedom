
var root
var workshop_gui_controller
var blueprint

func init_root(root_node):
    self.root = root_node
    self.workshop_gui_controller = self.root.bag.controllers.workshop_gui_controller

func bind_panel(bluepring_node):
    self.blueprint = bluepring_node
