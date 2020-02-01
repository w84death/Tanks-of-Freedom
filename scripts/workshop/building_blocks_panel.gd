
var root
var workshop
var workshop_gui_controller
var building_block_panel
var building_block_panel_wrapper

var terrain_button
var buildings_button
var units_button
var close_button

var blocks_area
var block_template = preload("res://gui/workshop/block.tscn")

var tiles

var terrain_blocks
var buildings_blocks
var units_blocks

var currently_selected_blocks

var current_blocks = []

func init_root(root_node):
    self.root = root_node
    self.workshop = self.root.bag.workshop
    self.workshop_gui_controller = self.root.bag.controllers.workshop_gui_controller
    self.tiles = self.root.bag.map_tiles

    self.terrain_blocks = [
        # name, tile id in sprite, type, blueprint id
        ["EREASE", self.tiles.ICON_EREASE, "terrain", -1],
        ["PLAIN", self.tiles.TERRAIN_PLAIN, "terrain", self.tiles.TERRAIN_PLAIN],
        ["DIRT", self.tiles.TERRAIN_DIRT, "terrain", self.tiles.TERRAIN_DIRT],
        ["FOREST", self.tiles.TERRAIN_FOREST, "terrain", self.tiles.TERRAIN_FOREST],
        ["MOUNTAIN", self.tiles.TERRAIN_MOUNTAINS, "terrain", self.tiles.TERRAIN_MOUNTAINS],
        ["RIVER", self.tiles.TERRAIN_RIVER, "terrain", self.tiles.TERRAIN_RIVER],
        ["BRIDGE", self.tiles.TERRAIN_BRIDGE, "terrain", self.tiles.TERRAIN_BRIDGE],
        ["CITY", self.tiles.TERRAIN_CITY, "terrain", self.tiles.TERRAIN_CITY],
        ["RUBBLE", self.tiles.TERRAIN_CITY_DESTROYED, "terrain", self.tiles.TERRAIN_CITY_DESTROYED],
        ["STATUE", self.tiles.TERRAIN_STATUE, "terrain", self.tiles.TERRAIN_STATUE],
        ["FENCE", self.tiles.TERRAIN_FENCE, "terrain", self.tiles.TERRAIN_FENCE],
        ["ROAD#1", self.tiles.TERRAIN_ROAD, "terrain", self.tiles.TERRAIN_ROAD],
        ["ROAD#2", self.tiles.TERRAIN_DIRT_ROAD, "terrain", self.tiles.TERRAIN_DIRT_ROAD],
        ["CONCRETE", self.tiles.TERRAIN_CONCRETE, "terrain", self.tiles.TERRAIN_CONCRETE]
    ]
    self.buildings_blocks = [
        ["HQ", self.tiles.TERRAIN_HQ_BLUE, "terrain", self.tiles.TERRAIN_HQ_BLUE],
        ["HQ", self.tiles.TERRAIN_HQ_RED, "terrain", self.tiles.TERRAIN_HQ_RED],
        ["BARRACKS", self.tiles.TERRAIN_BARRACKS_FREE, "terrain", self.tiles.TERRAIN_BARRACKS_FREE],
        ["FACTORY", self.tiles.TERRAIN_FACTORY_FREE, "terrain", self.tiles.TERRAIN_FACTORY_FREE],
        ["AIRPORT", self.tiles.TERRAIN_AIRPORT_FREE, "terrain", self.tiles.TERRAIN_AIRPORT_FREE],
        ["SPAWN", self.tiles.TERRAIN_SPAWN, "terrain", self.tiles.TERRAIN_SPAWN],
        ["GSM_TOWER", self.tiles.TERRAIN_TOWER_FREE, "terrain", self.tiles.TERRAIN_TOWER_FREE],
        ["BARRACKS", self.tiles.TERRAIN_BARRACKS_RED, "terrain", self.tiles.TERRAIN_BARRACKS_RED],
        ["FACTORY", self.tiles.TERRAIN_FACTORY_RED, "terrain", self.tiles.TERRAIN_FACTORY_RED],
        ["AIRPORT", self.tiles.TERRAIN_AIRPORT_RED, "terrain", self.tiles.TERRAIN_AIRPORT_RED],
        ["TOWER", self.tiles.TERRAIN_TOWER_RED, "terrain", self.tiles.TERRAIN_TOWER_RED],
        ["BARRACKS", self.tiles.TERRAIN_BARRACKS_BLUE, "terrain", self.tiles.TERRAIN_BARRACKS_BLUE],
        ["FACTORY", self.tiles.TERRAIN_FACTORY_BLUE, "terrain", self.tiles.TERRAIN_FACTORY_BLUE],
        ["AIRPORT", self.tiles.TERRAIN_AIRPORT_BLUE, "terrain", self.tiles.TERRAIN_AIRPORT_BLUE],
        ["TOWER", self.tiles.TERRAIN_TOWER_BLUE, "terrain", self.tiles.TERRAIN_TOWER_BLUE],
    ]
    self.units_blocks = [
        ["INFANTRY", self.tiles.UNIT_INFANTRY_BLUE, "units", 0],
        ["TANK", self.tiles.UNIT_TANK_BLUE, "units", 1],
        ["HELI", self.tiles.UNIT_HELICOPTER_BLUE, "units", 2],
        ["INFANTRY", self.tiles.UNIT_INFANTRY_RED, "units", 3],
        ["TANK", self.tiles.UNIT_TANK_RED, "units", 4],
        ["HELI", self.tiles.UNIT_HELICOPTER_RED, "units", 5],
        ["CIVILIAN", self.tiles.UNIT_CIVILIAN, "units", 6]
    ]

func bind_panel(building_block_panel_wrapper_node):
    self.building_block_panel_wrapper = building_block_panel_wrapper_node
    self.building_block_panel = self.building_block_panel_wrapper.get_node("center/building_blocks")

    self.terrain_button = self.building_block_panel.get_node("controls/terrain_button")
    self.buildings_button = self.building_block_panel.get_node("controls/buildings_button")
    self.units_button = self.building_block_panel.get_node("controls/units_button")
    self.blocks_area = self.building_block_panel.get_node("controls/blocks")
    self.close_button = self.building_block_panel.get_node("controls/close_button")

    self.terrain_button.connect("pressed", self, "_category_button_pressed", [self.terrain_blocks])
    self.buildings_button.connect("pressed", self, "_category_button_pressed", [self.buildings_blocks])
    self.units_button.connect("pressed", self, "_category_button_pressed", [self.units_blocks])
    self.close_button.connect("pressed", self, "hide")

    self.fill_blocks_panel(self.terrain_blocks)

func _category_button_pressed(category):
    self.root.sound_controller.play('menu')
    self.currently_selected_blocks = category
    self.fill_blocks_panel(category)

func reload_blocks():
    if self.currently_selected_blocks != null:
        self.fill_blocks_panel(self.currently_selected_blocks)
    else:
        self.fill_blocks_panel(self.terrain_blocks)

func show():
    self.building_block_panel_wrapper.show()

func hide():
    self.building_block_panel_wrapper.hide()
    self.workshop_gui_controller.navigation_panel.block_button.grab_focus()

func clear_blocks_panel():
    for block in self.current_blocks:
        self.blocks_area.remove_child(block)
        block.call_deferred("free")
    self.current_blocks = []

func fill_blocks_panel(blocks):
    var new_block
    var positionVAR = Vector2(20, 50)
    var index = 0
    self.clear_blocks_panel()
    for block in blocks:
        new_block = self.block_template.instance()
        new_block.get_node("tile").set_frame(block[1])
        new_block.get_node("select/name").set_text(tr("LABEL_WORKSHOP_" + block[0]))
        new_block.get_node("select").connect("pressed", self, "set_building_block_type", [block[2], block[3], block[0]])
        self.blocks_area.add_child(new_block)
        if index > 0 && index % 5 == 0:
            positionVAR.x = 20
            positionVAR.y = positionVAR.y + 100
        elif index > 0:
            positionVAR.x = positionVAR.x + 100
        new_block.set_pos(positionVAR)
        index = index + 1
        self.current_blocks.append(new_block)

func set_building_block_type(layer, tile_id, tile_name):
    self.root.sound_controller.play('menu')
    self.workshop.tool_type = layer
    self.workshop.brush_type = tile_id
    self.workshop_gui_controller.navigation_panel.set_block_label(tr("LABEL_WORKSHOP_" + tile_name))
    self.workshop.movement_mode = false
    self.hide()

func __trans(elements):
    for element in elements:
        element[0] = tr("LABEL_WORKSHOP_" + element[0] )

    return elements

