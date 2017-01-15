
var root
var bag
var workshop
var workshop_gui_controller
var file_panel
var file_panel_wrapper
var file_panel_top_controls

var position
var positions = [-48,50]
var toggle_button
var play_button
var save_button
var save_animation
var load_button
var pick_button
var file_name


var central_container

func init_root(root_node):
    self.root = root_node
    self.bag = root_node.bag
    self.workshop = self.root.bag.workshop
    self.workshop_gui_controller = self.root.bag.controllers.workshop_gui_controller

func bind_panel(file_panel_wrapper_node):
    self.file_panel_wrapper = file_panel_wrapper_node
    self.file_panel = self.file_panel_wrapper.get_node("center/file_panel")
    self.position = self.file_panel.get_pos()
    self.file_panel_top_controls = self.file_panel.get_node('controls/top')
    self.file_name = self.file_panel_top_controls.get_node("file_name")
    self.save_button = self.file_panel_top_controls.get_node("save_button")
    self.save_animation = self.file_panel_top_controls.get_node("progress_animation")
    self.pick_button = self.file_panel_top_controls.get_node("load_button_picker")
    self.load_button = self.file_panel_top_controls.get_node("load_button")

    self.toggle_button = self.file_panel.get_node("controls/file_button")
    self.play_button = self.file_panel.get_node("controls/play_button")

    self.play_button.connect("pressed", self, "play_button_pressed")
    self.save_button.connect("pressed", self, "save_button_pressed")
    self.load_button.connect("pressed", self, "load_button_pressed")
    self.pick_button.connect("pressed", self, "pick_button_pressed")
    self.toggle_button.connect("pressed", self, "_toggle_button_pressed")

    self.central_container = self.workshop.get_node("central_container")

func _toggle_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_file_panel()
    self.toggle_button.grab_focus()


func toggle_file_panel():
    if self.is_extended():
        self.position.y = self.positions[0]
        self.file_panel_top_controls.hide()
    else:
        self.position.y = self.positions[1]
        self.file_panel_top_controls.show()
    self.file_panel.set_pos(self.position)

func save_button_pressed():
    self.root.sound_controller.play('menu')
    self.workshop.save_map(self.file_name, true)

func load_button_pressed():
    self.root.sound_controller.play('menu')
    self.workshop.load_map(self.file_name, true)

func play_button_pressed():
    self.root.sound_controller.play('menu')
    self.show_skirmish_setup_panel()

func show_skirmish_setup_panel():
    self.hide_map_picker()
    self.central_container.show()
    self.bag.skirmish_setup.attach_panel(self.central_container)
    self.bag.skirmish_setup.connect(self, "hide_skirmish_setup_panel", "play_map_from_skirmish_setup_panel")
    self.bag.skirmish_setup.set_map_name('not important', self.file_name.get_text())
    self.bag.skirmish_setup.play_button.grab_focus()

func hide_skirmish_setup_panel():
    self.central_container.hide()
    self.bag.skirmish_setup.detach_panel()
    self.play_button.grab_focus()

func play_map_from_skirmish_setup_panel(map_name, is_remote = false):
    self.hide_skirmish_setup_panel()
    self.workshop.play_map()

func pick_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_map_picker()

func show_map_picker():
    self.central_container.show()
    self.bag.map_picker.attach_panel(self.central_container)
    self.bag.map_picker.connect(self, "load_map_from_picker")
    self.bag.map_picker.unlock_delete_mode_button()

func hide_map_picker():
    self.central_container.hide()
    self.bag.map_picker.detach_panel()

func toggle_map_picker():
    if self.is_map_picker_visible():
        self.hide_map_picker()
        self.toggle_button.grab_focus()
    else:
        self.show_map_picker()
        self.toggle_file_panel()
        self.root.bag.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()

func load_map_from_picker(selected_map_name, is_remote):
    self.workshop.load_map(selected_map_name, false, false, is_remote)
    self.file_name.set_text(selected_map_name)
    self.hide_map_picker()
    self.toggle_button.grab_focus()

func is_map_picker_visible():
    return self.bag.map_picker.is_attached_to(self.central_container)

func is_game_setup_visible():
    return self.bag.skirmish_setup.is_attached_to(self.central_container)

func is_extended():
    if self.position.y == self.positions[0]:
        return false
    return true
