var map
var root
var action_layer
var intraction_tiles = []

func init_root(root):
    self.root = root

func init_map(map_node):
    self.map = map_node
    self.action_layer = self.map.get_node("terrain/actions")

func reset():
    self.action_layer.clear()

func add_movement_indicator(tile, tile_type):
    self.action_layer.set_cell(tile.x, tile.y, tile_type)

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
            var distance = abs(start.x - tile.x) + abs(start.y - tile.y)
            var tile_type = 1
            if (distance > first_action_range):
                tile_type = 2

            self.add_movement_indicator(tile, tile_type)

    else:
        if target.object.group == 'unit':
            if target.object.player != current_player && self.root.dependency_container.battle_controller.can_attack(source.object, target.object):
                self.add_movement_indicator(tile, 3)
                self.interaction_tiles.append(tile)
        if target.object.group == 'building' && target.object.player != current_player && source.object.type == 0:
            self.add_movement_indicator(tile, 3)
            self.intraction_tiles.append(tile)

func mark_interaction_tiles():
    var tiles
    for tile in self.intraction_tiles:
        tiles = self.get_adjacement_tiles(tile)
        for adj_tile in tiles:
            if self.action_layer.get_cell(adj_tile.x, adj_tile.y) > 0:
                self.add_movement_indicator(adj_tile, 3)

func clear_interaction_tiles():
    self.intraction_tiles.clear()


func get_adjacement_tiles(tile):
    var mods = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
    var tiles = []
    for mod in mods:
        tiles.append(tile + mod)

    return tiles
