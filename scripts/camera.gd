
var root
var camera
var workshop_camera
var workshop_map
var abstract_map
var camera_zoom_range = [1,6]

func init_root(root_node):
	self.root = root_node
	self.camera = root_node.scale_root

func apply_default_camera():
	self.set_camera_zoom(Globals.get("tof/default_zoom"))

func camera_zoom_in():
	var scale = self.camera.get_scale()
	if scale.x < self.camera_zoom_range[1]:
		self.camera.set_scale(scale + Vector2(1,1))
		self.workshop_camera.set_scale(scale + Vector2(1,1))
		self.workshop_map.scale = self.workshop_camera.get_scale()
	if self.abstract_map.map != null:
		self.abstract_map.map.scale = self.camera.get_scale()
	self.root.dependency_container.controllers.menu_controller.update_zoom_label()
	self.root.dependency_container.controllers.menu_controller.update_background_scale()

func camera_zoom_out():
	var scale = self.camera.get_scale()
	if scale.x > self.camera_zoom_range[0]:
		self.camera.set_scale(scale - Vector2(1,1))
		self.workshop_camera.set_scale(scale - Vector2(1,1))
		self.workshop_map.scale = self.workshop_camera.get_scale()
	if self.abstract_map.map != null:
		self.abstract_map.map.scale = self.camera.get_scale()
	self.root.dependency_container.controllers.menu_controller.update_zoom_label()
	self.root.dependency_container.controllers.menu_controller.update_background_scale()

func set_camera_zoom(zoom_value):
	self.camera.set_scale(Vector2(zoom_value, zoom_value))
	self.workshop_camera.set_scale(Vector2(zoom_value, zoom_value))
	self.workshop_map.scale = self.workshop_camera.get_scale()
	self.root.dependency_container.controllers.menu_controller.update_background_scale()