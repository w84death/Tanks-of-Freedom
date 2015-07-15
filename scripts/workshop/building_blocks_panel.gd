
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

var terrain_blocks = [
    # name, tile id in sprite, type, blueprint id
    ["EREASE", 18, "terrain", -1],
    ["PLAIN", 0, "terrain", 1],
    ["FOREST", 1, "terrain", 2],
    ["MOUNTAIN", 2, "terrain", 3],
    ["RIVER", 3, "terrain", 17],
    ["BRIDGE", 8, "terrain", 18],
    ["CITY", 4, "terrain", 4],
    ["STATUE", 10, "terrain", 5],
    ["FENCE", 9, "terrain", 12],
    ["ROAD #1", 5, "terrain", 14],
    ["ROAD #2", 6, "terrain", 15],
    ["JOIN ROADS", 7, "terrain", 16],
]
var buildings_blocks = [
    ["HQ BLUE", 11, "terrain", 6],
    ["HQ RED", 12, "terrain", 7],
    ["BARRACKS", 13, "terrain", 8],
    ["FACTORY", 14, "terrain", 9],
    ["AIRPORT", 15, "terrain", 10],
    ["SPAWN", 17, "terrain", 13],
    ["GSM TOWER", 16, "terrain", 11],
    ["BARRACKS R", 19, "terrain", 8],
    ["FACTORY R", 20, "terrain", 9],
    ["AIRPORT R", 21, "terrain", 10],
    ["TOWER R", 22, "terrain", 11],
    ["BARRACKS B", 23, "terrain", 8],
    ["FACTORY B", 24, "terrain", 9],
    ["AIRPORT B", 25, "terrain", 10],
    ["TOWER B", 26, "terrain", 11],
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
