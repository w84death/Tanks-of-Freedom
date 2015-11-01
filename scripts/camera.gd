
var root
var camera
var workshop_camera
var workshop_map
var abstract_map
var camera_zoom_range = [0.5,2.5]

func init_root(root_node):
	self.root = root_node
	self.camera = root_node.camera

func apply_default_camera():
	self.set_camera_zoom(Globals.get("tof/default_zoom"))

func camera_zoom_do(direction):
	var scale = self.camera.get_zoom()
	if ( direction < 0 && scale.x > self.camera_zoom_range[0] ) or ( direction > 0 && scale.x < self.camera_zoom_range[1] ):
		self.camera.set_zoom(scale + (Vector2(0.25,0.25) * direction))
		self.workshop_camera.set_scale(scale + (Vector2(0.25,0.25) * direction))
		self.workshop_map.scale = self.workshop_camera.get_scale()
	if self.abstract_map.map != null:
		self.abstract_map.map.scale = self.camera.get_zoom()
	self.root.dependency_container.controllers.menu_controller.update_zoom_label()
	self.root.dependency_container.controllers.menu_controller.update_background_scale()

func camera_zoom_in():
	camera_zoom_do(-1)

func camera_zoom_out():
	camera_zoom_do(1)

func set_camera_zoom(zoom_value):
	self.camera.set_zoom(Vector2(zoom_value, zoom_value))
	self.workshop_camera.set_scale(Vector2(zoom_value, zoom_value))
	self.workshop_map.scale = self.workshop_camera.get_scale()
	self.root.dependency_container.controllers.menu_controller.update_background_scale()