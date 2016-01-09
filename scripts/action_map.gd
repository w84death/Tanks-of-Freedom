var map
var root
var action_layer
var red_tiles = []

func init_root(root):
    self.root = root

func init_map(map_node):
    self.map = map_node
    self.action_layer = self.map.get_node("terrain/actions")

func reset():
    self.action_layer.clear()

func find_movement_tiles(source_field, move_range):
    var tiles = {}
    var processing_queue = [{ 'field': source_field, 'depth': 0 }]
    var index = 0
    var visited_tiles = {}
    var depth
    var field
    var abstract_map = self.root.dependency_container.abstract_map
    visited_tiles[source_field.position] = true

    if move_range == 0:
        return {}

    while processing_queue.size() > index:
        field = processing_queue[index].field
        depth = processing_queue[index].depth

        if depth > 0:
            tiles[field.position] = depth

        if depth < move_range:
            for neighbour in field.get_neighbours():
                if neighbour.is_passable() and not visited_tiles.has(neighbour.position):
                    if root.dependency_container.fog_controller.is_fogged(neighbour.position):
                        continue
                    processing_queue.push_back({ 'field': neighbour, 'depth': depth + 1 })
                    visited_tiles[neighbour.position] = true
        index += 1

    return tiles

func add_movement_indicator(tile, tile_type):
    self.action_layer.set_cell(tile.x, tile.y, tile_type)

func mark_movement_tiles(source, tiles, first_action_range, current_player):
    var tile_type
    var field
    var distance
    var abstract_map = self.root.dependency_container.abstract_map
    var player_ap = self.root.dependency_container.controllers.action_controller.player_ap[current_player]

    for tile in tiles:
        if root.dependency_container.fog_controller.is_fogged(tile):
            continue
        field = abstract_map.get_field(tile)
        distance = tiles[tile]
        tile_type = 1

        for neighbour in field.get_neighbours():
            if neighbour.has_capturable_building(source.object):
                tile_type = 3
                break
            if neighbour.has_attackable_enemy(source.object):
                tile_type = 3
                break

        if distance > first_action_range || distance == player_ap:
            tile_type = 2

        self.add_movement_indicator(tile, tile_type)
