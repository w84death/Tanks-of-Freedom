
var root
var workshop_gui_controller
var workshop
var toolbox_panel
var toolbox_panel_wrapper

var fill_x_button
var fill_x_button_label
var fill_y_button
var fill_y_button_label
var fill_button
var clear_terrain_button
var clear_units_button
var theme_button
var close_button

var theme_rotation = {
	'summer' : 'fall',
	'fall' : 'winter',
	'winter' : 'summer'
}
var theme_names = {
	'summer' : 'LABEL_SUMMER',
	'fall' : 'LABEL_FALL',
	'winter' : 'LABEL_WINTER'
}

func init_root(root_node):
	self.root = root_node
	self.workshop_gui_controller = self.root.bag.controllers.workshop_gui_controller
	self.workshop = self.root.bag.workshop

func bind_panel(toolbox_panel_wrapper_node):
	self.toolbox_panel_wrapper = toolbox_panel_wrapper_node
	self.toolbox_panel = self.toolbox_panel_wrapper.get_node("center/toolbox")
	self.close_button = self.toolbox_panel.get_node("front/close")
	self.fill_x_button = self.toolbox_panel.get_node("front/x")
	self.fill_x_button_label = self.fill_x_button.get_node("label")
	self.fill_y_button = self.toolbox_panel.get_node("front/y")
	self.fill_y_button_label = self.fill_y_button.get_node("label")
	self.fill_button = self.toolbox_panel.get_node("front/fill")
	self.clear_terrain_button = self.toolbox_panel.get_node("front/clear_terrain")
	self.clear_units_button = self.toolbox_panel.get_node("front/clear_units")
	self.theme_button = self.toolbox_panel.get_node('front/theme')

	self.fill_x_button.connect("pressed", self, "fill_axis_button_pressed", [self.fill_x_button_label, 0])
	self.fill_y_button.connect("pressed", self, "fill_axis_button_pressed", [self.fill_y_button_label, 1])
	self.refresh_axis_button_label(self.fill_x_button_label, 0)
	self.refresh_axis_button_label(self.fill_y_button_label, 1)

	self.close_button.connect("pressed", self, "hide")

	self.fill_button.connect("pressed", self, "fill_button_pressed")
	self.clear_terrain_button.connect("pressed", self ,"_clear_button_pressed", [0])
	self.clear_units_button.connect("pressed", self, "_clear_button_pressed", [1])
	self.theme_button.connect("pressed", self, "_theme_button_pressed")

	self.refresh_theme_button()

func _clear_button_pressed(layer_id):
	self.root.sound_controller.play('menu')
	self.workshop.toolbox_clear(layer_id)

func _theme_button_pressed():
	self.root.sound_controller.play('menu')
	self.cycle_theme()

func show():
	self.toolbox_panel_wrapper.show()
	self.refresh_theme_button()

func hide():
	self.toolbox_panel_wrapper.hide()

func fill_button_pressed():
	self.root.sound_controller.play('menu')
	self.workshop_gui_controller.hide_toolbox_panel()
	self.workshop.toolbox_fill()
	self.workshop_gui_controller.navigation_panel.block_button.grab_focus()

func fill_axis_button_pressed(label, axis_index):
	self.root.sound_controller.play('menu')
	self.workshop.settings.fill_selected[axis_index] = self.workshop.settings.fill_selected[axis_index] + 1
	if self.workshop.settings.fill_selected[axis_index] == self.workshop.settings.fill.size():
		self.workshop.settings.fill_selected[axis_index] = 0
	self.refresh_axis_button_label(label, axis_index)

func refresh_axis_button_label(label, axis_index):
	label.set_text(str(self.workshop.settings.fill[self.workshop.settings.fill_selected[axis_index]]))

func cycle_theme():
	self.workshop.selected_tileset = self.theme_rotation[self.workshop.selected_tileset]
	self.refresh_theme_button()

func refresh_theme_button():
	self.theme_button.get_node('label').set_text(tr(self.theme_names[self.workshop.selected_tileset]))
