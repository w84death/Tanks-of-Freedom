
var root
var workshop_gui_controller
var workshop
var navigation_panel

var undo_button
var drag_button
var menu_button
var toolbox_button
var block_button
var block_button_label

func init_root(root_node):
    self.root = root_node
    self.workshop_gui_controller = self.root.dependency_container.controllers.workshop_gui_controller
    self.workshop = self.root.dependency_container.workshop

func bind_panel(navigation_panel_node):
    self.navigation_panel = navigation_panel_node
    self.menu_button = self.navigation_panel.get_node("controls/menu_button")
    self.undo_button = self.navigation_panel.get_node("controls/undo_button")
    self.drag_button = self.navigation_panel.get_node("controls/map_move_button")
    self.toolbox_button = self.navigation_panel.get_node("controls/toolbox_button")
    self.block_button = self.navigation_panel.get_node("controls/building_blocks_button")
    self.block_button_label = self.block_button.get_node("Label")

    self.menu_button.connect("pressed", self, "menu_button_pressed")
    self.undo_button.connect("pressed", self, "undo_button_pressed")
    self.drag_button.connect("pressed", self, "drag_button_pressed")
    self.toolbox_button.connect("pressed", self, "toolbox_button_pressed")
    self.block_button.connect("pressed", self, "block_button_pressed")

func menu_button_pressed():
    self.root.sound_controller.play('menu')
    self.workshop.toggle_menu()

func undo_button_pressed():
    self.root.sound_controller.play('menu')
    self.workshop.undo_last_action()

func drag_button_pressed():
    self.root.sound_controller.play('menu')
    self.mark_drag_button()
    self.workshop.movement_mode = true
    self.set_block_label("MOVE MAP")

func reset_buttons():
    return

func mark_drag_button():
    self.reset_buttons()

func mark_block_button():
    self.reset_buttons()

func toolbox_button_pressed():
    self.root.sound_controller.play('menu')
    self.workshop_gui_controller.toggle_toolbox_panel()

func block_button_pressed():
    self.root.sound_controller.play('menu')
    self.workshop_gui_controller.toggle_block_blocks()

func reset_block_label():
    self.set_block_label("BUILD TERRAIN")

func set_block_label(label):
    self.block_button_label.set_text(label)
