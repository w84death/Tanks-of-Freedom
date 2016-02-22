const FILE_PATH = 'user://__current.save'

var root_node
var root_tree
var data = {}
var t
var bag
var building_map
var buildings
var unit_map
var loaded_data

func init_root(root):
    self.root_node = root
    self.root_tree = root.get_tree()
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
    self.loaded_data = self.bag.file_handler.read(self.FILE_PATH)

    self.bag.root.load_map(self.loaded_data['template_name'], self.loaded_data['from_workshop'], true)

func load_map_state():
    self.remove_units_from_map()
    self.apply_units_from_save()
    self.apply_saved_buildings()

func remove_units_from_map():
    var units = self.root_tree.get_nodes_in_group('units')
    for unit in units:
        unit.get_parent().remove_child(unit)
        unit.remove_from_group('units')

func apply_saved_buildings():
    return

func apply_saved_buildings():
    return

func apply_saved_environment_settings():
    return

func get_active_player_id():
    return self.loaded_data['active_player']

func get_active_player_key():
    return 'cpu_' + str(self.loaded_data['active_player'])

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

func invalidate_save_file():
    var save_data = {
        'map' : [],
        'is_current' : false,
        'md5' : 0
    }
    self.bag.file_handler.write(self.FILE_PATH, save_data)

func validate_data(save_data):
    var md5 = save_data['md5']
    save_data.erase('md5')
    if md5 == save_data.to_json().md5_text():
        return true

    return false


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
        self.data[pos]['meta'] = {'hp' : unit.life, 'ap' : unit.ap, 'player' : unit.player, 'type' : unit.type}

func __get_building_id(type, owner):
    return self.building_map[owner][type]


func store_map_in_binary_file():
    var save_data
    var map_array = []
    for pos in self.data:
        map_array.append(self.data[pos])

    save_data = {
        'map' : map_array,
        'is_current' : true,
        'template_name' : self.root_node.current_map_name,
        'from_workshop' : self.root_node.workshop_file_name,
        'active_player' : self.root_node.action_controller.current_player
    }

    save_data['md5'] = save_data.to_json().md5_text()

    self.bag.file_handler.write(self.FILE_PATH, save_data)