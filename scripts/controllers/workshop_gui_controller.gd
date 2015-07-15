
var root
var workshop

var blueprint = preload("res://scripts/workshop/blueprint.gd").new()

var toolbox_panel = preload("res://scripts/workshop/toolbox_panel.gd").new()
var building_blocks_panel = preload("res://scripts/workshop/building_blocks_panel.gd").new()
var message_popup
var file_panel = preload("res://scripts/workshop/file_panel.gd").new()
var navigation_panel = preload("res://scripts/workshop/navigation_panel.gd").new()

func init_root(root_node):
    self.root = root_node
    self.workshop = self.root.dependency_container.workshop
    self.root.add_child(self.root.dependency_container.workshop)
    self.blueprint.init_root(root_node)
    self.toolbox_panel.init_root(root_node)
    self.building_blocks_panel.init_root(root_node)
    self.file_panel.init_root(root_node)
    self.navigation_panel.init_root(root_node)
    self.bind_workshop(self.root.dependency_container.workshop)
    self.workshop.hide()

func bind_workshop(workshop_node):
    self.blueprint.bind_panel(self.workshop.get_node("blueprint"))
    self.toolbox_panel.bind_panel(self.workshop.get_node("toolbox_panel"))
    self.building_blocks_panel.bind_panel(self.workshop.get_node("building_blocks_panel"))
    self.file_panel.bind_panel(self.workshop.get_node("file_card"))
    self.navigation_panel.bind_panel(self.workshop.get_node("navigation_panel/center/navigation_panel"))
    self.workshop = workshop_node

func show_toolbox_panel():
    self.toolbox_panel.show()
    self.workshop.painting_allowed = false

func hide_toolbox_panel():
    self.toolbox_panel.hide()
    self.workshop.painting_allowed = true

func toggle_toolbox_panel():
    if self.toolbox_panel.toolbox_panel.is_visible():
        self.hide_toolbox_panel()
    else:
        self.show_toolbox_panel()

func show_block_panel():
    self.building_blocks_panel.show()

func hide_block_panel():
    self.building_blocks_panel.hide()

func toggle_block_blocks():
    if self.building_blocks_panel.building_block_panel.is_visible():
        self.hide_block_panel()
    else:
        self.show_block_panel()
