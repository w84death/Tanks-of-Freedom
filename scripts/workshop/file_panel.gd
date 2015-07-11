
var root
var workshop_gui_controller
var file_panel

func init_root(root_node):
    self.root = root_node
    self.workshop_gui_controller = self.root.dependency_container.controllers.workshop_gui_controller

func bind_panel(file_panel_node):
    self.file_panel = file_panel_node
