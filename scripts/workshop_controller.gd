extends Control

var root
var bag
var is_working = false
var is_suspended = true

var selector = preload('res://gui/selector.tscn').instance()
var selector_position = Vector2(0,0)
var map_pos

var hud_message
var hud_message_box
var hud_message_box_button
var hud_message_box_title
var hud_message_box_message

var toolset_active_page = 0
var tool_type = "terrain"
var brush_type = 0

var restore_file_name = "restore_map"

var map
var camera
var terrain
var units
var painting = false
var painting_allowed = true
var history = []
var paint_count = 0
var autosave_after = 10
var painting_motion = false
var movement_mode = true
var tileset
var is_camera_drag = false

var settings = {
	fill = [8,12,16,20,24,32],
	fill_selected = [0,0],
}

var selected_tileset = 'summer'

func init(root):
	self.root = root
	self.bag = root.bag
	self.tileset = self.bag.map_tiles
	terrain.add_child(selector)
	map.set_default_zoom()
	set_process_input(true)
	self.selected_tileset = self.map.map_file.DEFAULT_THEME

func _ready():
	init_gui()

func init_gui():
	camera = get_node("viewport/camera")
	map = camera.get_node("scale/map")
	terrain = map.get_node("terrain")
	units = map.get_node("terrain/units")

	# message
	hud_message = self.get_node("message")
	hud_message_box = hud_message.get_node("center/message")
	hud_message_box_button = hud_message_box.get_node("button")
	hud_message_box_button.connect("pressed", self, "_hud_message_box_button_pressed")
	self.load_map(restore_file_name, false, true)

func _hud_message_box_button_pressed():
	self.root.sound_controller.play('menu')
	self.close_message()

func add_action(params):
	var last_brush

	if params.tool_type == "terrain":
		last_brush = terrain.get_cell(params.position.x,params.position.y)

	if params.tool_type == "units":
		last_brush = units.get_cell(params.position.x,params.position.y)

	history.append({
		position = params.position,
		tool_type = params.tool_type,
		brush_type = last_brush
		})
	paint_count += 1
	if not painting_motion and paint_count >= autosave_after:
		self.save_map(restore_file_name)
		paint_count = 0

func undo_last_action():
	var last_action
	if self.history.size() > 0:
		last_action = history[history.size()-1]
		self.paint(last_action.position,last_action.tool_type,last_action.brush_type, true)
		history.remove_and_collide(history.size()-1)

func toolbox_fill():
	map.fill(settings.fill[settings.fill_selected[0]],settings.fill[settings.fill_selected[1]])
	self.center_camera()

func toolbox_clear(layer):
	if layer == 0:
		self.map.clear_layer(0)
	if layer == 1:
		self.map.clear_layer(1)

func play_map():
	self.save_map(self.restore_file_name)
	self.is_working = false
	self.is_suspended = true
	self.bag.controllers.workshop_menu_controller.hide_workshop()
	self.root.load_map("workshop", self.restore_file_name, false, false, self, "post_play_map")

func post_play_map():
	self.root.hide_menu()
	self.bag.match_state.set_workshop_map()
	self.root.hud_controller.enable_back_to_workshop()
	self.bag.controllers.hud_panel_controller.info_panel.set_map_name("workshop temporary map")
	self.bag.fog_controller.hide_fog()

func save_map(name, input = false):
	if input:
		name = name.get_text()
	self.map.theme = self.selected_tileset
	if not map.save_map(name):
		self.show_message(tr("LABEL_WORKSHOP_FAILURE"), tr("MSG_WORKSHOP_FILE_ERROR_NAME"), tr("MSG_WORKSHOP_CHECK_TYPOS"), tr("LABEL_OK"))

func load_map(name, input = false, suppress=false, is_remote = false):
	if input:
		name = name.get_text()
	if not map.load_map(name, is_remote, false):
		if not suppress:
			self.show_message(tr("LABEL_WORKSHOP_FAILURE"), tr("MSG_WORKSHOP_FILE_NOT_FOUND"), tr("MSG_WORKSHOP_CHECK_TYPOS"), tr("LABEL_OK"))
	else:
		self.selected_tileset = self.map.theme

func paint(position, tool_type = null, brush_type = null, undo_action = false):
	if hud_message.is_visible():
		return false

	if tool_type == null:
		tool_type = self.tool_type
	if brush_type == null:
		brush_type = self.brush_type


	if position.x < 0 or position.y < 0 or position.x >= self.bag.abstract_map.MAP_MAX_X or position.y >= self.bag.abstract_map.MAP_MAX_Y:
		return false
	else:
		if tool_type == "terrain":
			if brush_type == -1 and units.get_cell(position.x,position.y) > -1:
				if not undo_action:
					add_action({position=Vector2(position.x,position.y),tool_type="units"})
				units.set_cell(position.x,position.y,brush_type)
			else:
				if terrain.get_cell(position.x,position.y) != brush_type:
					if not undo_action:
						add_action({position=Vector2(position.x,position.y),tool_type="terrain"})
					terrain.set_cell(position.x,position.y,brush_type)

		if tool_type == "units":
			if units.get_cell(position.x,position.y) != brush_type:
				if terrain.get_cell(position.x, position.y) in [self.tileset.TERRAIN_PLAIN, self.tileset.TERRAIN_DIRT, self.tileset.TERRAIN_ROAD, self.tileset.TERRAIN_DIRT_ROAD, self.tileset.TERRAIN_BRIDGE, self.tileset.TERRAIN_SPAWN, self.tileset.TERRAIN_CONCRETE]:
					if not undo_action:
						add_action({position=Vector2(position.x,position.y),tool_type="units"})
					units.set_cell(position.x,position.y,brush_type)
				else:
					return false
	units.raise()
	selector.raise()
	return true

func _input(event):
	if self.is_working && not self.is_suspended && self.painting_allowed:
		var camera_pos = self.camera.get_offset()
		var game_scale = self.camera.get_zoom()

		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			self.bag.gamepad.handle_input(event)
		if self.root.is_pandora and event is InputEventKey:
			self.bag.pandora.handle_input(event)

		if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
			if not self.movement_mode:
				if event.pressed:
					painting = true
				else:
					painting = false
					painting_motion = false
			else:
				self.is_camera_drag = event.pressed

		if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT:
			self.is_camera_drag = event.pressed

		if event is InputEventMouseMotion || event is InputEventMouseButton:
			var new_selector_x = (event.x - self.root.half_screen_size.x + camera_pos.x/game_scale.x) * (game_scale.x)
			var new_selector_y = (event.y - self.root.half_screen_size.y + camera_pos.y/game_scale.y) * (game_scale.y) + 5
			selector_position = terrain.world_to_map(Vector2(new_selector_x, new_selector_y))
			var position = terrain.map_to_world(selector_position)
			position.y = position.y + 4
			selector.set_position(position)

		if (event is InputEventMouseMotion):
			painting_motion = true
			if self.is_camera_drag:
				camera_pos.x = camera_pos.x - event.relative_x * game_scale.x
				camera_pos.y = camera_pos.y - event.relative_y * game_scale.y
				self.camera.set_offset(camera_pos)

		if (event is InputEventMouseMotion or event is InputEventMouseButton) and painting and not self.bag.workshop_dead_zone.is_dead_zone(event.x, event.y):
			#map_pos = terrain.get_global_position() / Vector2(map.scale.x, map.scale.y)
			#var position = terrain.map_to_world(selector_position)
			#position.x = (position.x + map_pos.x) * map.scale.x
			#position.y = (position.y + map_pos.y) * map.scale.y
			#if not self.bag.workshop_dead_zone.is_dead_zone(position.x, position.y):
			self.paint(selector_position)

		if event is InputEventKey:
			if event.scancode == KEY_Z && event.pressed:
				self.undo_last_action()

		if event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP && event.pressed:
			self.bag.camera.camera_zoom_in()
		if event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN && event.pressed:
			self.bag.camera.camera_zoom_out()

	if Input.is_action_pressed('ui_cancel') && not self.root.is_map_loaded && (event.type != InputEvent.KEY || not event.is_echo()):
		self.toggle_menu()

func toggle_menu():
	if not self.is_working:
		return

	if self.bag.menu_back.perform_back():
		return

	if self.is_visible():
		self.is_suspended = false
		self.bag.controllers.workshop_menu_controller.show_workshop()
	else:
		self.is_suspended = true
		self.bag.controllers.workshop_menu_controller.hide_workshop()

func show_message(title, msg, footer, button):
	self.hud_message_box.show_message(title, msg, footer, button)
	self.hud_message.show()

func close_message():
	self.hud_message.hide()

func center_camera():
	var center_position = Vector2(self.bag.abstract_map.MAP_MAX_X / 2, self.bag.abstract_map.MAP_MAX_Y / 2)
	self.set_camera_map_position(center_position)
	self.set_selector_map_position(center_position)

func set_camera_map_position(position):
	if position.x < 0 or position.y < 0 or position.x > self.bag.abstract_map.MAP_MAX_X or position.y > self.bag.abstract_map.MAP_MAX_Y:
		return

	self.camera.set_offset(self.terrain.map_to_world(position))

func set_selector_map_position(pos):
	if pos.x < 0 or pos.y < 0 or pos.x > self.bag.abstract_map.MAP_MAX_X or pos.y > self.bag.abstract_map.MAP_MAX_Y:
		return

	var position = self.terrain.map_to_world(pos)
	position.y += 4
	selector.set_position(position)
	self.selector_position = pos

func show():
	if not self.bag.gamepad.gamepad_detected:
		self.center_camera()
	camera.set_zoom(self.bag.camera.camera.get_zoom())
	.show()

