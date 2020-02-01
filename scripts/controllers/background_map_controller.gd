var background_map
var root

func init_root(root_node):
	self.root = root_node

func load_background_map():
	self.background_map = self.root.map_template.instance()
	self.background_map._init_bag(self.root.bag)
	self.background_map.is_dead = true
	self.background_map.switch_to_tileset(self.root.main_tileset)
	self.background_map.fill_map_from_data_array(self.root.bag.menu_background_map.map_data)
	self.background_map.show_blueprint = false
	self.background_map.get_node('fog_of_war').hide()
	self.root.scale_root.add_child(self.background_map)
	self.__flush_group("units")
	self.__flush_group("buildings")
	self.__flush_group("terrain")
	self.update_background_scale()

func show_background_map():
	if self.background_map != null:
		self.background_map.show()

func hide_background_map():
	if self.background_map != null:
		self.background_map.hide()

func update_background_scale():
	if self.background_map != null:
		self.background_map.scale = self.root.scale_root.get_scale()
		if not self.root.is_map_loaded:
			self.root.camera.set_pos(Vector2(-200, 500))

func __flush_group(name):
	var collection = self.root.get_tree().get_nodes_in_group(name)
	for entity in collection:
		entity.remove_from_group(name)