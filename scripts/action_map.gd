var map
var root
var action_layer

func init_root(root):
	self.root = root

func init_map(map_node):
	self.map = map_node
	self.action_layer = self.map.get_node("terrain/actions")

func reset():
	self.action_layer.clear()

func add_movement_indicator(tile, tile_type):
	self.action_layer.set_cell(tile.x,tile.y, tile_type)

func mark_movement_tile(source, tile, first_action_range, unit_moved, current_player):
	if self.root.dependency_container.abstract_map.map.fog_controller.is_fogged(tile.x, tile.y):
		return

	var target = self.root.dependency_container.abstract_map.get_field(tile)

	#outside map
	if target.terrain_type == -1:
		return

	if target.object == null:
		if self.root.dependency_container.movement_controller.can_move(source, target):
			var start = source.object.get_pos_map();
			var distance = abs(start.x-tile.x)+abs(start.y-tile.y)
			var tile_type = 1;
			if (distance > first_action_range || unit_moved):
				tile_type = 2;

			self.add_movement_indicator(tile, tile_type)
	else:
		if target.object.group == 'unit':
			if target.object.player != current_player && self.root.dependency_container.battle_controller.can_attack(source.object, target.object):
				self.add_movement_indicator(tile, 3)
		if target.object.group == 'building' && target.object.player != current_player && source.object.type == 0:
			self.add_movement_indicator(tile, 3)