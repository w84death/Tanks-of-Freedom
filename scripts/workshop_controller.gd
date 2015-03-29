
extends Control

var root

var selector = preload('res://gui/selector.xscn').instance()
var selector_position = Vector2(0,0)
var game_scale
var map_pos

var hud_file
var hud_file_play_button
var hud_file_save_button
var hud_file_load_button
var hud_file_name

var hud_toolset
var hud_toolset_blocks
var hud_toolset_plain
var hud_toolset_forest
var hud_toolset_mountains
var hud_toolset_river
var hud_toolset_active
var tool_type = "terrain"
var brush_type = 1

var map
var terrain
var units

const MAP_MAX_X = 64
const MAP_MAX_Y = 64

func init_gui():
	hud_file = self.get_node("top/file_card")
	hud_file_name = hud_file.get_node("name")
	hud_file_play_button = hud_file.get_node("play")
	hud_file_save_button = hud_file.get_node("save")
	hud_file_load_button = hud_file.get_node("load")
	hud_file_play_button.connect("pressed", self, "play_map")
	hud_file_save_button.connect("pressed", self, "save_map")
	hud_file_load_button.connect("pressed", self, "load_map")
	
	map = get_node("blueprint/center/scale/map")
	terrain = map.get_node("terrain")
	units = map.get_node("terrain/units")

	hud_toolset = self.get_node("bottom/toolset")
	hud_toolset_blocks = hud_toolset.get_node("blocks")
	hud_toolset_plain = hud_toolset_blocks.get_node("plain")
	hud_toolset_forest = hud_toolset_blocks.get_node("forest")
	hud_toolset_mountains = hud_toolset_blocks.get_node("mountains")
	hud_toolset_river = hud_toolset_blocks.get_node("river")
	
	hud_toolset_active = hud_toolset_plain.get_node("active")
	hud_toolset_active.show()
	
	hud_toolset_plain.connect("pressed", self, "select_tool", ["terrain",1,hud_toolset_plain.get_node("active")])
	hud_toolset_forest.connect("pressed", self, "select_tool", ["terrain",2,hud_toolset_forest.get_node("active")])
	hud_toolset_mountains.connect("pressed", self, "select_tool", ["terrain",3,hud_toolset_mountains.get_node("active")])
	hud_toolset_river.connect("pressed", self, "select_tool", ["terrain",17,hud_toolset_river.get_node("active")])


func play_map():
	map.save_map("temp_map")
	self.hide()
	root.load_map("workshop", "temp_map")
	return

func save_map():
	map.save_map(hud_file_name.get_text())

func load_map():
	map.load_map(hud_file_name.get_text())
	
func select_tool(tool_type,brush_type,button):
	if tool_type == "terrain":
		hud_toolset_active.hide()
		hud_toolset_active = button
		hud_toolset_active.show()
		self.tool_type = tool_type
		self.brush_type = brush_type
	
	return

func paint(position):
	if brush_type > -1:
		terrain.set_cell(position.x,position.y,brush_type)
	units.raise()
	selector.raise()
	return

func init(root):
	self.root = root
	terrain.add_child(selector)
	map.set_default_zoom()
	map.move_to_map(Vector2(-25,20))
	set_process_input(true)

func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):
		map_pos = terrain.get_pos()
		selector_position = terrain.world_to_map( Vector2((event.x/map.scale.x)-map_pos.x,(event.y/map.scale.y)-map_pos.y))
		var position = terrain.map_to_world(selector_position)
		selector.set_pos(position)
	# MOUSE SELECT
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.pressed and event.button_index == BUTTON_LEFT):
			self.paint(selector_position)

func _ready():
	init_gui()
	
	pass


