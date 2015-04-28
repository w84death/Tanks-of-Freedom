var fog_of_war
var map_controller
var terrain
var root

func _init(map_controller_object, terrain_node):
	map_controller = map_controller_object
	terrain = terrain_node
	root = map_controller.root

func init_node():
    fog_of_war = map_controller.get_node("fog_of_war")

func fill_fog():
	fog_of_war.clear()
	var sprite = 0
	for x in range(0, map_controller.MAP_MAX_X):
		for y in range(0, map_controller.MAP_MAX_Y):
			if terrain.get_cell(x,y) > -1:
				if rand_seed(x)[0] % 2 == 0:
					sprite = 0
				else:
					sprite = 1
				fog_of_war.set_cell(x,y,sprite)
	randomize()

func clear_fog_range(center, size):
	var x_min = center.x-size
	var x_max = center.x+size+1
	var y_min = center.y-size
	var y_max = center.y+size+1

	for x in range(x_min,x_max):
		for y in range(y_min,y_max):
			fog_of_war.set_cell(x,y,-1)
	return

func clear():
    fog_of_war.clear()

func clear_cloud(x, y):
    fog_of_war.set_cell(x, y, -1)

func add_cloud(x, y, sprite):
    fog_of_war.set_cell(x, y, sprite)

func move_cloud(pos):
    fog_of_war.set_pos(pos)

func clear_fog():
	self.fill_fog()
	var units = root.get_tree().get_nodes_in_group("units")
	var buildings = root.get_tree().get_nodes_in_group("buildings")
	for unit in units:
		# cpu vs cpu mode
		# show everything aka spectator mode
		if root.settings['cpu_0'] && root.settings['cpu_1']:
			self.clear_fog_range(unit.position_on_map,2)
		else:
			if ( unit.player == 0 and not root.settings['cpu_0'] ) or (unit.player == 1 and not root.settings['cpu_1']):
				self.clear_fog_range(unit.position_on_map,2)

	for building in buildings:
		# cpu vs cpu mode
		# show everything aka visitor mode
		if root.settings['cpu_0'] && root.settings['cpu_1']:
			self.clear_fog_range(building.position_on_map,3)
		else:
			if building.player > -1: # ocupy
				if ( building.player == 0 and not root.settings['cpu_0'] ) or (building.player == 1 and not root.settings['cpu_1']):
					self.clear_fog_range(building.position_on_map,3)
	return