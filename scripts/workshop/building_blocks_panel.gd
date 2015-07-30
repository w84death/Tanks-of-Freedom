
var root
var workshop
var workshop_gui_controller
var building_block_panel
var building_block_panel_wrapper

var terrain_button
var buildings_button
var units_button

var blocks_area
var block_template = preload("res://gui/workshop/block.xscn")

const TERRAIN_PLAIN = 0
const TERRAIN_FOREST = 1
const TERRAIN_MOUNTAINS = 2
const TERRAIN_RIVER = 3
const TERRAIN_CITY = 4
const TERRAIN_ROAD = 5
const TERRAIN_DIRT_ROAD = 6
const TERRAIN_DIRT = 7
const TERRAIN_BRIDGE = 8
const TERRAIN_FENCE = 9
const TERRAIN_STATUE = 10
const TERRAIN_HQ_BLUE = 11
const TERRAIN_HQ_RED = 12
const TERRAIN_BARRACKS_FREE = 13
const TERRAIN_FACTORY_FREE = 14
const TERRAIN_AIRPORT_FREE = 15
const TERRAIN_TOWER_FREE = 16
const TERRAIN_SPAWN = 17
const TERRAIN_BARRACKS_BLUE = 19
const TERRAIN_FACTORY_BLUE = 20
const TERRAIN_AIRPORT_BLUE = 21
const TERRAIN_TOWER_BLUE = 22
const TERRAIN_BARRACKS_RED = 23
const TERRAIN_FACTORY_RED = 24
const TERRAIN_AIRPORT_RED = 25
const TERRAIN_TOWER_RED = 26
const ICON_EREASE = 18

var terrain_blocks = [
    # name, tile id in sprite, type, blueprint id
    ["EREASE", self.ICON_EREASE, "terrain", -1],
    ["PLAIN", self.TERRAIN_PLAIN, "terrain", self.TERRAIN_PLAIN],
    ["DIRT", self.TERRAIN_DIRT, "terrain", self.TERRAIN_DIRT],
    ["FOREST", self.TERRAIN_FOREST, "terrain", self.TERRAIN_FOREST],
    ["MOUNTAIN", self.TERRAIN_MOUNTAINS, "terrain", self.TERRAIN_MOUNTAINS],
    ["RIVER", self.TERRAIN_RIVER, "terrain", self.TERRAIN_RIVER],
    ["BRIDGE", self.TERRAIN_BRIDGE, "terrain", self.TERRAIN_BRIDGE],
    ["CITY", self.TERRAIN_CITY, "terrain", self.TERRAIN_CITY],
    ["STATUE", self.TERRAIN_STATUE, "terrain", self.TERRAIN_STATUE],
    ["FENCE", self.TERRAIN_FENCE, "terrain", self.TERRAIN_FENCE],
    ["ROAD #1", self.TERRAIN_ROAD, "terrain", self.TERRAIN_ROAD],
    ["ROAD #2", self.TERRAIN_DIRT_ROAD, "terrain", self.TERRAIN_DIRT_ROAD]
]
var buildings_blocks = [
    ["HQ BLUE", self.TERRAIN_HQ_BLUE, "terrain", self.TERRAIN_HQ_BLUE],
    ["HQ RED", self.TERRAIN_HQ_RED, "terrain", self.TERRAIN_HQ_RED],
    ["BARRACKS", self.TERRAIN_BARRACKS_FREE, "terrain", self.TERRAIN_BARRACKS_FREE],
    ["FACTORY", self.TERRAIN_FACTORY_FREE, "terrain", self.TERRAIN_FACTORY_FREE],
    ["AIRPORT", self.TERRAIN_AIRPORT_FREE, "terrain", self.TERRAIN_AIRPORT_FREE],
    ["SPAWN", self.TERRAIN_SPAWN, "terrain", self.TERRAIN_SPAWN],
    ["GSM TOWER", self.TERRAIN_TOWER_FREE, "terrain", self.TERRAIN_TOWER_FREE],
    ["BARRACKS R", self.TERRAIN_BARRACKS_RED, "terrain", self.TERRAIN_BARRACKS_RED],
    ["FACTORY R", self.TERRAIN_FACTORY_RED, "terrain", self.TERRAIN_FACTORY_RED],
    ["AIRPORT R", self.TERRAIN_AIRPORT_RED, "terrain", self.TERRAIN_AIRPORT_RED],
    ["TOWER R", self.TERRAIN_TOWER_RED, "terrain", self.TERRAIN_TOWER_RED],
    ["BARRACKS B", self.TERRAIN_BARRACKS_BLUE, "terrain", self.TERRAIN_BARRACKS_BLUE],
    ["FACTORY B", self.TERRAIN_FACTORY_BLUE, "terrain", self.TERRAIN_FACTORY_BLUE],
    ["AIRPORT B", self.TERRAIN_AIRPORT_BLUE, "terrain", self.TERRAIN_AIRPORT_BLUE],
    ["TOWER B", self.TERRAIN_TOWER_BLUE, "terrain", self.TERRAIN_TOWER_BLUE],
]
var units_blocks = [
    ["INFANTRY B", 27, "units", 0],
    ["TANK B", 28, "units", 1],
    ["HELI B", 29, "units", 2],
    ["INFANTRY R", 30, "units", 3],
    ["TANK R", 31, "units", 4],
    ["HELI B", 32, "units", 5]
]

var current_blocks = []

func init_root(root_node):
    self.root = root_node
    self.workshop = self.root.dependency_container.workshop
    self.workshop_gui_controller = self.root.dependency_container.controllers.workshop_gui_controller

func bind_panel(building_block_panel_wrapper_node):
    self.building_block_panel_wrapper = building_block_panel_wrapper_node
    self.building_block_panel = self.building_block_panel_wrapper.get_node("center/building_blocks")

    self.terrain_button = self.building_block_panel.get_node("controls/terrain_button")
    self.buildings_button = self.building_block_panel.get_node("controls/buildings_button")
    self.units_button = self.building_block_panel.get_node("controls/units_button")
    self.blocks_area = self.building_block_panel.get_node("controls/blocks")

    self.terrain_button.connect("pressed", self, "fill_blocks_panel", [self.terrain_blocks])
    self.buildings_button.connect("pressed", self, "fill_blocks_panel", [self.buildings_blocks])
    self.units_button.connect("pressed", self, "fill_blocks_panel", [self.units_blocks])

    self.fill_blocks_panel(self.terrain_blocks)

func show():
    self.building_block_panel_wrapper.show()

func hide():
    self.building_block_panel_wrapper.hide()

func clear_blocks_panel():
    for block in self.current_blocks:
        self.blocks_area.remove_child(block)
        block.queue_free()
    self.current_blocks = []

func fill_blocks_panel(blocks):
    var new_block
    var position = Vector2(20, 50)
    var index = 0
    self.clear_blocks_panel()
    for block in blocks:
        new_block = self.block_template.instance()
        new_block.get_node("tile").set_frame(block[1])
        new_block.get_node("select/name").set_text(block[0])
        new_block.get_node("select").connect("pressed", self, "set_building_block_type", [block[2], block[3], block[0]])
        self.blocks_area.add_child(new_block)
        if index > 0 && index % 5 == 0:
            position.x = 20
            position.y = position.y + 100
        elif index > 0:
            position.x = position.x + 100
        new_block.set_pos(position)
        index = index + 1
        self.current_blocks.append(new_block)

func set_building_block_type(layer, tile_id, tile_name):
    self.workshop.tool_type = layer
    self.workshop.brush_type = tile_id
    self.workshop_gui_controller.navigation_panel.set_block_label(tile_name)
    self.workshop.movement_mode = false
    self.hide()
