var tile_types = StringArray([
    'plain','plain','plain','plain','plain','plain','plain','plain',
    'plain','plain','plain','plain','plain','road','road','road',
    'road','river','road',
    'road','road','road','road','road','road','road','road',
    'road','road','road','road','road','road','road','road',
    'road','road','road','road','road','road','road','road',
    'road','road','road','road',
    'river','river','river','river','river','river','river','river'
])

const TERRAIN_COST = 1

func move_object(from, to, action_cost=TERRAIN_COST):

    var player_stats = from.object.get_stats()
    var position = to.position

    if self.has_enough_ap(from, action_cost):
    #if self.can_move(from, to, movement_tiles):
        player_stats.ap = player_stats.ap - action_cost
        from.object.set_stats(player_stats)

        to.object = from.object
        #mark ant trail
        from.mark_trail(to.position, from.object.player)
        from.object = null
        to.object.set_pos_map(to.position)

        return true
    else:

        return false

func has_enough_ap(from, cost):
    var unit_stats = from.object.get_stats()
    if unit_stats.ap >= cost:
        return true
    else:
        return false

func can_move(from, to):
    var unit_stats = from.object.get_stats()
    var action_cost = self.get_terrain_cost()
    if unit_stats.ap >= action_cost:
        return true
    else:
        return false

func get_terrain_cost():
    return TERRAIN_COST