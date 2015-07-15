
var root
var workshop
var workshop_gui_controller
var file_panel
var file_panel_wrapper

var position
var positions = [-34,108]
var toggle_button
var play_button
var save_button
var load_button
var file_name
var floppy

func init_root(root_node):
    self.root = root_node
    self.workshop = self.root.dependency_container.workshop
    self.workshop_gui_controller = self.root.dependency_container.controllers.workshop_gui_controller

func bind_panel(file_panel_wrapper_node):
    self.file_panel_wrapper = file_panel_wrapper_node
    self.file_panel = self.file_panel_wrapper.get_node("center/file_panel")
    self.position = self.file_panel.get_pos()

    self.floppy = self.file_panel.get_node("controls/floppy/anim")
    self.file_name = self.file_panel.get_node("controls/file_name")
    self.toggle_button = self.file_panel.get_node("controls/file_button")
    self.play_button = self.file_panel.get_node("controls/play_button")
    self.save_button = self.file_panel.get_node("controls/save_button")
    self.load_button = self.file_panel.get_node("controls/load_button")

    self.play_button.connect("pressed", self.workshop, "play_map")
    self.save_button.connect("pressed", self, "save_button_pressed")
    self.load_button.connect("pressed", self, "load_button_pressed")
    self.toggle_button.connect("pressed", self, "toggle_file_panel")

func toggle_file_panel():
    if self.position.y == self.positions[0]:
        self.position.y = self.positions[1]
    else:
        self.position.y = self.positions[0]
    self.file_panel.set_pos(self.position)

func save_button_pressed():
    self.workshop.save_map(self.file_name, true)
    self.floppy.play("save")

func load_button_pressed():
    self.workshop.load_map(self.file_name, true)
    self.floppy.play("save")