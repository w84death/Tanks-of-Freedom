const FILE_PATH = 'user://__current.save'

var root_node
var data = {}
var t
var bag
var building_map
var buildings
var unit_map

func init_root(root):
    root_node = root
    self.bag = self.root_node.dependency_container
    t = self.bag.map_tiles

    self.building_map = {
        'none' : [-1, t.TERRAIN_BARRACKS_FREE, t.TERRAIN_FACTORY_FREE, t.TERRAIN_AIRPORT_FREE, t.TERRAIN_TOWER_FREE],
        'red'  : [t.TERRAIN_HQ_RED , t.TERRAIN_BARRACKS_RED, t.TERRAIN_FACTORY_RED, t.TERRAIN_AIRPORT_RED, t.TERRAIN_TOWER_RED],
        'blue' : [t.TERRAIN_HQ_BLUE , t.TERRAIN_BARRACKS_BLUE, t.TERRAIN_FACTORY_BLUE, t.TERRAIN_AIRPORT_BLUE, t.TERRAIN_TOWER_BLUE]
    }

    self.unit_map = {
        0 : [t.UNIT_INFANTRY_RED, t.UNIT_TANK_RED, t.UNIT_HELICOPTER_RED],
        1 : [t.UNIT_INFANTRY_BLUE, t.UNIT_TANK_BLUE, t.UNIT_HELICOPTER_BLUE]
    }

func load_state():
    print('test')

func save_state():
    var pos
    self.data.clear()
    for field_row in self.root_node.bag.abstract_map.fields:
        for field in field_row:
            pos = Vector2(field.position.x, field.position.y)
            self.data[pos] = {'x' : field.position.x, 'y': field.position.y, 'terrain': field.terrain_type, 'unit' : -1, 'meta': {}}

    #buildings
    self.__fill_building_data('none')
    self.__fill_building_data('red')
    self.__fill_building_data('blue')
    #units
    self.__fill_unit_data()

    self.store_map_in_binary_file()
    self.store_map_in_plain_file(self.data)

func invalidate_save_file():
    var save_data = {
        'map' : [],
        'is_current' : false,
        'md5' : 0
    }
    self.bag.file_handler.write(self.FILE_PATH, save_data)

func __fill_building_data(owner):
    if owner == 'red':
        buildings = self.bag.positions.buildings_player_red
    elif owner == 'blue':
        buildings = self.bag.positions.buildings_player_blue
    else:
        buildings = self.bag.positions.buildings_player_none

    for building_pos in buildings:
        data[building_pos]['building'] = self.__get_building_id(buildings[building_pos].type, owner)

func __fill_unit_data():
    var units = self.bag.positions.all_units
    var unit
    for pos in units:
        unit = units[pos]
        self.data[pos]['unit'] = self.unit_map[unit.player][unit.type]
        self.data[pos]['meta'] = {'hp' : unit.life, 'ap' : unit.ap}

func __get_building_id(type, owner):
    return self.building_map[owner][type]


func store_map_in_binary_file():
    var save_data
    var map_array = []
    for pos in self.data:
        map_array.append(self.data[pos])

    save_data = {
        'map' : map_array,
        'is_current' : true
    }

    save_data['md5'] = save_data.to_json().md5_text()

    self.bag.file_handler.write(self.FILE_PATH, save_data)

func store_map_in_plain_file(data):
    var file = self.bag.file_handler.file
    file.open(self.FILE_PATH + ".gd", File.WRITE)
    file.store_line("var map_data = [")
    var cell_line
    var cell
    for pos in data:
        cell = data[pos]
        cell_line = "'x': " + str(cell.x) + ", "
        cell_line += "'y': " + str(cell.y) + ", "
        cell_line += "'terrain': " + str(cell.terrain) + ", "
        cell_line += "'unit': " + str(cell.unit) + ", "
        cell_line += "'meta': " + "{ "

        if cell.meta.size() :
            for meta_name in cell.meta:
                cell_line += "'" + meta_name + "': " + str(cell.meta[meta_name]) + ", "

        cell_line += "}"
        file.store_line("	{" + cell_line + "},")
    file.store_line("]")
    file.close()






