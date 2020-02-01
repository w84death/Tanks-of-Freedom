extends "res://scripts/bag_aware.gd"

var waypoint = preload('waypoint.gd')

func create(positionVAR, subtype=waypoint.TYPE_LEVEL_1):
	return self.waypoint.new(positionVAR, subtype)

func create_for_building(building, all_neighbours=true):
	var spawn_point = building.spawn_point
	var building_owner = building.player

	var nearby_tiles = self.bag.positions.get_nearby_tiles(building.position_on_map, 1)
	var waypoints = []
	var waypoint_obj

	for tile in nearby_tiles:
		var field = self.bag.abstract_map.get_field(tile)
		if field.is_passable():
			if tile == spawn_point:
				waypoint_obj = self.waypoint.new(tile, self.waypoint.TYPE_SPAWN_POINT)
			elif(all_neighbours):
				waypoint_obj = self.waypoint.new(tile, self.waypoint.TYPE_BULDING_AREA)

			field.waypoint = waypoint_obj

			waypoint_obj.point_of_interest = building
			waypoint_obj.update_status()

			waypoints.append(waypoint_obj)
			self.bag.abstract_map.tilemap.get_node("back").add_child(waypoint_obj)

	return waypoints

func prepare_for_map():
	for building in self.bag.positions.buildings:
		self.create_for_building(building)

func update_waypoints():
	for waypoint in self.bag.positions.waypoints.values():
		waypoint.update_status()

func mark_building_as_blocked(building):
	var nearby_tiles = self.bag.positions.get_nearby_tiles(building.position_on_map, 1)
	for tile in nearby_tiles:
		var field = self.bag.abstract_map.get_field(tile)
		if field.has_waypoint():
			field.waypoint.mark_blocked()


