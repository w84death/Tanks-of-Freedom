
var root
var game_logic
var camera
var workshop_map
var abstract_map
var camera_zoom_range = [0.5,2.5]
var camera_zoom_levels = [0.125, 0.25, 0.5, 1, 1.5]
var camera_zoom_level_pos = 2
var bag

var mouse_dragging = false

var pos
var game_size
var scale
var sX = 0
var sY = 0
var k = 0.90
var target = Vector2(0,0)
var camera_follow = true

var temp_delta = 0
var panning = false

const MAP_STEP = 0.01
const NEAR_THRESHOLD = 20
const NEAR_SCREEN_THRESHOLD = 0.2
const PAN_THRESHOLD = 20

var do_cinematic_pan = false

func init_root(root_node):
	self.root = root_node
	self.bag = self.root.dependency_container
	self.camera = self.root.get_node("/root/game/viewport/camera")
	self.game_logic = self.root.get_node("/root/game")
	self.camera_zoom_level_pos = self.root.settings['camera_zoom']
	self.update_zoom()

func update_zoom():
	self.scale = self.camera.get_zoom()

func get_pos():
	return self.camera.get_offset()

func set_pos(position):
	self.camera.set_offset(position)
	self.target = position
	self.pos = position
	self.sX = position.x
	self.sY = position.y

func get_scale():
	return self.scale

func get_camera_zoom():
	return self.scale

func apply_default_camera():
	self.set_camera_zoom(self.camera_zoom_levels[self.camera_zoom_level_pos])

func camera_zoom_do(direction):
	var new_scale
	if ( direction < 0 && scale.x > self.camera_zoom_levels[0] ) or ( direction > 0 && scale.x < self.camera_zoom_levels[4] ):
		self.camera_zoom_level_pos = self.camera_zoom_level_pos + direction
		new_scale = self.camera_zoom_levels[self.camera_zoom_level_pos]
		self.scale = Vector2(new_scale, new_scale)
		self.camera.set_zoom(self.scale)
		self.root.dependency_container.workshop.camera.set_zoom(self.scale)
		self.root.game_scale = self.scale
		self.root.settings['camera_zoom'] = self.camera_zoom_level_pos
		self.root.write_settings_to_file()
	self.bag.controllers.menu_controller.update_zoom_label()
	self.bag.controllers.menu_controller.update_background_scale()

func camera_zoom_in():
	camera_zoom_do(-1)

func camera_zoom_out():
	camera_zoom_do(1)

func set_camera_zoom(zoom_value):
	self.camera.set_zoom(Vector2(zoom_value, zoom_value))
	self.scale = Vector2(zoom_value, zoom_value)
	self.bag.controllers.menu_controller.update_background_scale()

func move_to_map(target):
	if not root.settings['camera_follow']:
		return

	if not self.camera_follow && self.bag.fog_controller.is_fogged(target):
		return

	if not mouse_dragging:
		self.game_size = self.game_logic.get_size()
		var target_position = self.abstract_map.tilemap.map_to_world(target)
		var diff_x = target_position.x - self.sX
		var diff_y = target_position.y - self.sY
		var near_x = game_size.x * (NEAR_SCREEN_THRESHOLD * scale.x)
		var near_y = game_size.y * (NEAR_SCREEN_THRESHOLD * scale.y)

		if diff_x > -near_x && diff_x < near_x && diff_y > -near_y && diff_y < near_y:
			return
		self.target = target_position
		self.panning = true

func process(delta):
	if not pos == target:
		temp_delta += delta
		if temp_delta > MAP_STEP:
			var diff_x = self.target.x - self.sX
			var diff_y = self.target.y - self.sY

			panning = self.__do_panning(diff_x, diff_y)
			if diff_x > -NEAR_THRESHOLD && diff_x < NEAR_THRESHOLD && diff_y > -NEAR_THRESHOLD && diff_y < NEAR_THRESHOLD:
				target = pos
			else:
				self.sX = self.sX + diff_x * temp_delta;
				self.sY = self.sY + diff_y * temp_delta;
				var new_pos = Vector2(self.sX, self.sY)
				self.camera.set_offset(new_pos)
			temp_delta = 0
	else:
		panning = false

	if self.do_cinematic_pan:
		self.do_awesome_cinematic_pan()
		if self.awesome_explosions_interval_counter == self.awesome_explosions_interval:
			self.do_awesome_random_explosions()
			self.awesome_explosions_interval_counter = 0
		else:
			self.awesome_explosions_interval_counter += 1

func __do_panning(diff_x, diff_y):
	if diff_x > -PAN_THRESHOLD && diff_x < PAN_THRESHOLD && diff_y > -PAN_THRESHOLD && diff_y < PAN_THRESHOLD:
		return false

	return true