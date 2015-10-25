var fog_of_war
var map_controller
var terrain
var root

var bag

func _init_bag(bag):
    self.bag = bag
    self.root = bag.root

var fog_pattern = []
var current_fog_state = []

func init_node(map_controller_object, terrain_node):
    self.map_controller = map_controller_object
    self.terrain = terrain_node
    self.fog_of_war = map_controller.get_node("fog_of_war")
    self.build_fog_pattern()

func is_fogged(x, y):
    return current_fog_state[y][x] > -1

func build_fog_pattern():
    var sprite = 0
    var uniq_num
    var row_array
    var pattern_array
    for y in range(0, map_controller.MAP_MAX_Y):
        row_array = []
        pattern_array = []
        for x in range(0, map_controller.MAP_MAX_X):
            sprite = -1
            if terrain.get_cell(x,y) > -1:
                uniq_num = int(sin(x+y)+cos(x*y))
                if  uniq_num % 2 == 0:
                    if uniq_num % 8 == 0:
                        sprite = 0
                    else:
                        sprite = 1
                else:
                    if uniq_num % 3 == 0:
                        sprite = 2
                    else:
                        sprite = 3
            row_array.insert(x, sprite)
            pattern_array.insert(x, sprite)
        self.fog_pattern.insert(y, pattern_array)
        self.current_fog_state.insert(y, row_array)

func apply_fog():
    for x in range(0, map_controller.MAP_MAX_X):
        for y in range(0, map_controller.MAP_MAX_Y):
            if terrain.get_cell(x,y) > -1:
                fog_of_war.set_cell(x, y, self.current_fog_state[y][x])

func fill_fog():
    for x in range(0, map_controller.MAP_MAX_X):
        for y in range(0, map_controller.MAP_MAX_Y):
            if terrain.get_cell(x,y) > -1:
                self.current_fog_state[y][x] = self.fog_pattern[y][x]

func clear_fog_range(center, size):
    var x_min = center.x-size
    var x_max = center.x+size+1
    var y_min = center.y-size
    var y_max = center.y+size+1

    for x in range(x_min,x_max):
        for y in range(y_min,y_max):
            if x >= 0 && y >= 0:
                self.current_fog_state[y][x] = -1
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
    var current_player = 0
    var positions = []
    if root.action_controller != null:
        current_player = root.action_controller.current_player

    var units = self.__get_units_to_unhide(current_player)
    for position in units:
        #taking visibility parameter from unit
        self.__remove_fog(position, units[position].visibility)
    for position in self.__get_buildings_to_unhide(current_player):
        self.__remove_fog(position, 3)

    self.apply_fog()

func __get_units_to_unhide(player):
    if root.settings['cpu_0'] && root.settings['cpu_1']:
        return self.bag.positions.all_units
    else:
        if root.settings['cpu_' + str(player)]:
            player = (player + 1) % 2
        return self.bag.positions.get_player_units(player)

func __get_buildings_to_unhide(player):
    if root.settings['cpu_0'] && root.settings['cpu_1']:
        return self.bag.positions.buildings_player_none
    else:
        if root.settings['cpu_' + str(player)]:
            player = (player + 1) % 2
        return self.bag.positions.get_player_buildings(player)

func __remove_fog(position_on_map, view_range):
    self.clear_fog_range(position_on_map, view_range)
