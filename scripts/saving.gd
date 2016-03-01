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

var saved_settings = ['cpu_0', 'cpu_1', 'turns_cap', 'easy_mode']

func init_root(root):
    self.root_node = root
    self.root_tree = root.get_tree()
    self.bag = self.root_node.bag
    t = self.bag.map_tiles

    self.building_map = {
        'none' : [-1, t.TERRAIN_BARRACKS_FREE, t.TERRAIN_FACTORY_FREE, t.TERRAIN_AIRPORT_FREE, t.TERRAIN_TOWER_FREE],
        'red'  : [t.TERRAIN_HQ_RED , t.TERRAIN_BARRACKS_RED, t.TERRAIN_FACTORY_RED, t.TERRAIN_AIRPORT_RED, t.TERRAIN_TOWER_RED],
        'blue' : [t.TERRAIN_HQ_BLUE , t.TERRAIN_BARRACKS_BLUE, t.TERRAIN_FACTORY_BLUE, t.TERRAIN_AIRPORT_BLUE, t.TERRAIN_TOWER_BLUE]
    }

    self.unit_map = {
        0 : [0, 1, 2],
        1 : [3, 4, 5]
    }

func load_save_file_contents():
    self.loaded_data = self.bag.file_handler.read(self.FILE_PATH)
    if self.loaded_data == false:
        self.loaded_data = {
            'map' : [],
            'is_current' : false,
            'md5' : 0
        }

func load_state():
    self.load_save_file_contents()

    self.bag.root.load_map(self.loaded_data['template_name'], self.loaded_data['from_workshop'], true)

func load_map_state():
    self.remove_units_from_map()
    self.remove_terrain_objects_from_map()
    self.apply_units_from_save()
    self.apply_saved_terrain()

func remove_units_from_map():
    self.remove_objects_group_from_map('units')

func remove_terrain_objects_from_map():
    self.remove_objects_group_from_map('terrain')

func remove_objects_group_from_map(group_tag):
    var objects = self.root_tree.get_nodes_in_group(group_tag)
    for object in objects:
        if object.group == 'terrain' && object.unique_type_id == t.CITY_FENCE:
            continue
        object.get_parent().remove_child(object)
        object.remove_from_group(group_tag)
        object.queue_free()

func apply_units_from_save():
    var new_unit
    for field in self.loaded_data['map']:
        if field['unit'] != -1:
            new_unit = self.root_node.current_map.spawn_unit(field['x'], field['y'], field['unit'])
            new_unit.add_to_group('units')
            new_unit.set_ap(field['meta']['ap'])
            new_unit.set_hp(field['meta']['hp'])
            new_unit.kills = field['meta']['kills']

func apply_saved_buildings():
    var abstract_field
    for field in self.loaded_data['map']:
        if field['building'] != -1:
            abstract_field = self.bag.abstract_map.get_field(Vector2(field['x'], field['y']))
            abstract_field.object.claim(field['meta']['owner'], field['meta']['turn_claimed'])

func apply_saved_terrain():
    var terrain_object
    for field in self.loaded_data['map']:
        if field['terrain'] > -1:
            self.root_node.current_map_terrain.set_cell(field['x'], field['y'], field['terrain'])
            if field['meta'].has('is_terrain') and field['meta']['is_terrain']:
                print('terrain: ', field['meta']['type'])
                terrain_object = self.get_terrain_object_by_unique_type(field['meta']['type'])
                if field['meta']['frame'] > 0:
                    terrain_object.set_frame(field['meta']['frame'])
                for i in range(field['meta']['damage']):
                    terrain_object.set_damage()
                self.root_node.current_map.map_layer_front.add_child(terrain_object)
                terrain_object.set_pos(self.root_node.current_map_terrain.map_to_world(Vector2(field['x'], field['y'])))

func get_terrain_object_by_unique_type(unique_type_id):
    if unique_type_id == self.t.CITY_SMALL_1:
        return self.root_node.current_map.map_city_small[0].instance()
    if unique_type_id == self.t.CITY_SMALL_2:
        return self.root_node.current_map.map_city_small[1].instance()
    if unique_type_id == self.t.CITY_SMALL_3:
        return self.root_node.current_map.map_city_small[2].instance()
    if unique_type_id == self.t.CITY_SMALL_4:
        return self.root_node.current_map.map_city_small[3].instance()
    if unique_type_id == self.t.CITY_SMALL_5:
        return self.root_node.current_map.map_city_small[4].instance()
    if unique_type_id == self.t.CITY_SMALL_6:
        return self.root_node.current_map.map_city_small[5].instance()

    if unique_type_id == self.t.CITY_BIG_1:
        return self.root_node.current_map.map_city_big[0].instance()
    if unique_type_id == self.t.CITY_BIG_2:
        return self.root_node.current_map.map_city_big[1].instance()
    if unique_type_id == self.t.CITY_BIG_3:
        return self.root_node.current_map.map_city_big[2].instance()
    if unique_type_id == self.t.CITY_BIG_4:
        return self.root_node.current_map.map_city_big[3].instance()

    if unique_type_id == self.t.CITY_STATUE:
        return self.root_node.current_map.map_statue.instance()
    if unique_type_id == self.t.COUNTRY_FOREST_MOUNTAIN:
        return self.root_node.current_map.map_non_movable.instance()


func apply_saved_environment_settings():
    for settings in self.saved_settings:
        self.root_node.settings[settings] = self.loaded_data[settings]
    self.apply_saved_action_state()

func apply_saved_action_state():
    self.root_node.action_controller.player_ap[0] = self.loaded_data['player_0_ap']
    self.root_node.action_controller.player_ap[1] = self.loaded_data['player_1_ap']
    self.root_node.action_controller.turn         = self.loaded_data['turn']
    #self.root_node.action_controller.battle_stats = self.loaded_data['battle_stats']

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
            self.data[pos] = {'x' : field.position.x, 'y': field.position.y, 'terrain': field.terrain_type, 'unit' : -1, 'building' : -1, 'meta': {}}
            if field.object != null and field.object.group == 'terrain' and field.object.unique_type_id != t.CITY_FENCE:
                self.data[pos]['meta'] = {
                    'is_terrain' : true,
                    'damage' : field.object.damage,
                    'type' : field.object.unique_type_id,
                    'frame' : field.object.get_frame()
                }

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
        data[building_pos]['meta'] = {'owner' : buildings[building_pos].player, 'turn_claimed' : buildings[building_pos].turn_claimed}

func __fill_unit_data():
    var units = self.bag.positions.all_units
    var unit
    for pos in units:
        unit = units[pos]
        self.data[pos]['unit'] = self.unit_map[unit.player][unit.type]
        self.data[pos]['meta'] = {'hp' : unit.life, 'ap' : unit.ap, 'kills' : unit.kills}

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
        'active_player' : self.root_node.action_controller.current_player,
        'player_0_ap' : self.root_node.action_controller.player_ap[0],
        'player_1_ap' : self.root_node.action_controller.player_ap[1],
        'turn': self.root_node.action_controller.turn,
        'battle_stats' : self.root_node.action_controller.battle_stats.get_stats()
    }

    for settings in self.saved_settings:
        save_data[settings] = self.root_node.settings[settings]

    save_data['md5'] = save_data.to_json().md5_text()

    self.bag.file_handler.write(self.FILE_PATH, save_data)

func is_save_available():
    self.load_save_file_contents()
    if self.loaded_data == null or not self.loaded_data.has('is_current'):
        return false
    return self.loaded_data['is_current']
