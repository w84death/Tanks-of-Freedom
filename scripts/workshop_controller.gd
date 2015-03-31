
extends Control

var root
var is_working = true

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
var hud_toolset_blocks_pages = []
var hud_toolset_paginator
var hud_toolset_next_button
var hud_toolset_prev_button
var hud_toolset_active

#0
var hud_toolset_plain
var hud_toolset_forest
var hud_toolset_mountains
var hud_toolset_river
var hud_toolset_bridge

#1
var hud_toolset_city
var hud_toolset_statue
var hud_toolset_fence
var hud_toolset_road_city
var hud_toolset_road_country
var hud_toolset_road_mix

#2
var hud_toolset_hq_blue
var hud_toolset_hq_red
var hud_toolset_barracks
var hud_toolset_factory
var hud_toolset_airport
var hud_toolset_exit
var hud_toolset_tower

#3
var hud_toolset_soldier_blue
var hud_toolset_tank_blue
var hud_toolset_helicopter_blue
var hud_toolset_soldier_red
var hud_toolset_tank_red
var hud_toolset_helicopter_red

var hud_message
var hud_message_box
var hud_message_title
var hud_message_message

var toolset_active_page = 0
var tool_type = "terrain"
var brush_type = 1

var restore_file_name = "restore_map"

var map
var terrain
var units
var painting = false

const MAP_MAX_X = 64
const MAP_MAX_Y = 64

func init_gui():
	hud_file = self.get_node("file_card/center")
	hud_file_name = hud_file.get_node("name")
	hud_file_play_button = hud_file.get_node("play")
	hud_file_save_button = hud_file.get_node("save")
	hud_file_load_button = hud_file.get_node("load")
	hud_file_play_button.connect("pressed", self, "play_map")
	hud_file_save_button.connect("pressed", self, "save_map", [hud_file_name.get_text()])
	hud_file_load_button.connect("pressed", self, "load_map", [hud_file_name.get_text()])
	
	map = get_node("blueprint/center/scale/map")
	terrain = map.get_node("terrain")
	units = map.get_node("terrain/units")

	hud_toolset = self.get_node("toolset/center")
	hud_toolset_blocks = hud_toolset.get_node("blocks")
	hud_toolset_blocks_pages.append(hud_toolset_blocks.get_node("0"))
	hud_toolset_blocks_pages.append(hud_toolset_blocks.get_node("1"))
	hud_toolset_blocks_pages.append(hud_toolset_blocks.get_node("2"))
	hud_toolset_blocks_pages.append(hud_toolset_blocks.get_node("3"))
	hud_toolset_paginator = hud_toolset.get_node("paginator")
	hud_toolset_next_button = hud_toolset.get_node("next")
	hud_toolset_prev_button = hud_toolset.get_node("prev")
	
	hud_toolset_next_button.connect("pressed", self, "toolset_next_page")
	hud_toolset_prev_button.connect("pressed", self, "toolset_prev_page")

	#0
	hud_toolset_plain = hud_toolset_blocks_pages[0].get_node("plain")
	hud_toolset_forest = hud_toolset_blocks_pages[0].get_node("forest")
	hud_toolset_mountains = hud_toolset_blocks_pages[0].get_node("mountains")
	hud_toolset_river = hud_toolset_blocks_pages[0].get_node("river")
	hud_toolset_bridge = hud_toolset_blocks_pages[0].get_node("bridge")

	#1
	hud_toolset_city = hud_toolset_blocks_pages[1].get_node("city")
	hud_toolset_statue = hud_toolset_blocks_pages[1].get_node("statue")
	hud_toolset_fence = hud_toolset_blocks_pages[1].get_node("fence")
	hud_toolset_road_city = hud_toolset_blocks_pages[1].get_node("road_city")
	hud_toolset_road_country = hud_toolset_blocks_pages[1].get_node("road_country")
	hud_toolset_road_mix = hud_toolset_blocks_pages[1].get_node("road_mix")
	
	#2
	hud_toolset_hq_blue = hud_toolset_blocks_pages[2].get_node("hq_blue")
	hud_toolset_hq_red = hud_toolset_blocks_pages[2].get_node("hq_red")
	hud_toolset_barracks = hud_toolset_blocks_pages[2].get_node("barracks")
	hud_toolset_factory = hud_toolset_blocks_pages[2].get_node("factory")
	hud_toolset_airport = hud_toolset_blocks_pages[2].get_node("airport")
	hud_toolset_exit = hud_toolset_blocks_pages[2].get_node("exit")
	hud_toolset_tower = hud_toolset_blocks_pages[2].get_node("tower")

	#3
	hud_toolset_soldier_blue = hud_toolset_blocks_pages[3].get_node("soldier_blue")
	hud_toolset_tank_blue = hud_toolset_blocks_pages[3].get_node("tank_blue")
	hud_toolset_helicopter_blue = hud_toolset_blocks_pages[3].get_node("helicopter_blue")
	hud_toolset_soldier_red = hud_toolset_blocks_pages[3].get_node("soldier_red")
	hud_toolset_tank_red = hud_toolset_blocks_pages[3].get_node("tank_red")
	hud_toolset_helicopter_red = hud_toolset_blocks_pages[3].get_node("helicopter_red")
	
	hud_toolset_active = hud_toolset_plain.get_node("active")
	hud_toolset_active.show()
	
	# message
	hud_message = self.get_node("message")
	
	#0
	hud_toolset_plain.connect("pressed", self, "select_tool", ["terrain",1,hud_toolset_plain.get_node("active")])
	hud_toolset_forest.connect("pressed", self, "select_tool", ["terrain",2,hud_toolset_forest.get_node("active")])
	hud_toolset_mountains.connect("pressed", self, "select_tool", ["terrain",3,hud_toolset_mountains.get_node("active")])
	hud_toolset_river.connect("pressed", self, "select_tool", ["terrain",17,hud_toolset_river.get_node("active")])
	hud_toolset_bridge.connect("pressed", self, "select_tool", ["terrain",18,hud_toolset_bridge.get_node("active")])
	#1
	hud_toolset_city.connect("pressed", self, "select_tool", ["terrain",4,hud_toolset_city.get_node("active")])
	hud_toolset_statue.connect("pressed", self, "select_tool", ["terrain",5,hud_toolset_statue.get_node("active")])
	hud_toolset_fence.connect("pressed", self, "select_tool", ["terrain",12,hud_toolset_fence.get_node("active")])
	hud_toolset_road_city.connect("pressed", self, "select_tool", ["terrain",14,hud_toolset_road_city.get_node("active")])
	hud_toolset_road_country.connect("pressed", self, "select_tool", ["terrain",15,hud_toolset_road_country.get_node("active")])
	hud_toolset_road_mix.connect("pressed", self, "select_tool", ["terrain",16,hud_toolset_road_mix.get_node("active")])
	#2
	hud_toolset_hq_blue.connect("pressed", self, "select_tool", ["terrain",6,hud_toolset_hq_blue.get_node("active")])
	hud_toolset_hq_red.connect("pressed", self, "select_tool", ["terrain",7,hud_toolset_hq_red.get_node("active")])
	hud_toolset_barracks.connect("pressed", self, "select_tool", ["terrain",8,hud_toolset_barracks.get_node("active")])
	hud_toolset_factory.connect("pressed", self, "select_tool", ["terrain",9,hud_toolset_factory.get_node("active")])
	hud_toolset_airport.connect("pressed", self, "select_tool", ["terrain",10,hud_toolset_airport.get_node("active")])
	hud_toolset_exit.connect("pressed", self, "select_tool", ["terrain",13,hud_toolset_exit.get_node("active")])
	hud_toolset_tower.connect("pressed", self, "select_tool", ["terrain",11,hud_toolset_tower.get_node("active")])
	#3
	hud_toolset_soldier_blue.connect("pressed", self, "select_tool", ["units",0,hud_toolset_soldier_blue.get_node("active")])
	hud_toolset_tank_blue.connect("pressed", self, "select_tool", ["units",1,hud_toolset_tank_blue.get_node("active")])
	hud_toolset_helicopter_blue.connect("pressed", self, "select_tool", ["units",2,hud_toolset_helicopter_blue.get_node("active")])
	hud_toolset_soldier_red.connect("pressed", self, "select_tool", ["units",3,hud_toolset_soldier_red.get_node("active")])
	hud_toolset_tank_red.connect("pressed", self, "select_tool", ["units",4,hud_toolset_tank_red.get_node("active")])
	hud_toolset_helicopter_red.connect("pressed", self, "select_tool", ["units",5,hud_toolset_helicopter_red.get_node("active")])
	self.hud_message.show_message("Welcome!",["This is workshop. A place to create awesome maps.","Keep in mind that this tool is still in developement and may contain nasty bugs."])
	
	self.load_map(restore_file_name)
	
func toolset_next_page():
	hud_toolset_blocks_pages[toolset_active_page].hide()
	toolset_active_page += 1
	if toolset_active_page >= hud_toolset_blocks_pages.size():
		toolset_active_page = 0
	hud_toolset_blocks_pages[toolset_active_page].show()
	hud_toolset_paginator.set_frame(toolset_active_page)
	return

func toolset_prev_page():
	hud_toolset_blocks_pages[toolset_active_page].hide()
	toolset_active_page -= 1
	if toolset_active_page < 0:
		toolset_active_page = hud_toolset_blocks_pages.size()-1
	hud_toolset_blocks_pages[toolset_active_page].show()
	hud_toolset_paginator.set_frame(toolset_active_page)
	return

func check_map_integrity():
	var hq_red_check = false
	var hq_blue_check = false
	
	for x in range(MAP_MAX_X):
		for y in range(MAP_MAX_Y):
			if terrain.get_cell(x,y) == 6:
				hq_blue_check = true
			if terrain.get_cell(x,y) == 7:
				hq_red_check = true
		if hq_red_check and hq_blue_check:
			return true
	return false

func play_map():
	self.save_map(restore_file_name)
	if self.check_map_integrity():
		self.is_working = false
		self.hide()
		root.load_map("workshop", restore_file_name)
	else:
		self.hud_message.show_message("HQ missing", ["In this map mode there need to be HQ building for each player. Blue and Red."])
	return

func save_map(name):
	map.save_map(name)

func load_map(name):
	map.load_map(name)
	
func select_tool(tool_type,brush_type,button):
	hud_toolset_active.hide()
	hud_toolset_active = button
	self.tool_type = tool_type
	self.brush_type = brush_type
	hud_toolset_active.show()
	return

func paint(position):
	if brush_type > -1:
		if position.x < 0 or position.y < 0 or position.x >= MAP_MAX_X or position.y >= MAP_MAX_Y:
			return false
		else:
			if tool_type == "terrain":
				terrain.set_cell(position.x,position.y,brush_type)
			if tool_type == "units":
				if terrain.get_cell(position.x, position.y) in [1,13,14,15,16,17,18]:
					units.set_cell(position.x,position.y,brush_type)
				else:
					self.hud_message.show_message("Invalid field", ["Unit can be placed only on land, river and roads."])
					return false
	units.raise()
	selector.raise()
	return true

func init(root):
	self.root = root
	terrain.add_child(selector)
	map.set_default_zoom()
	set_process_input(true)

func _input(event):
	if self.is_working:
		if(event.type == InputEvent.MOUSE_BUTTON):
			if (event.button_index == BUTTON_LEFT):
				if event.pressed:
					painting = true
				else:
					painting = false
					self.save_map(restore_file_name)
	
		if (event.type == InputEvent.MOUSE_MOTION):
			map_pos = terrain.get_global_pos() / Vector2(map.scale.x,map.scale.y)
			selector_position = terrain.world_to_map( Vector2((event.x/map.scale.x)-map_pos.x,(event.y/map.scale.y)-map_pos.y))
			var position = terrain.map_to_world(selector_position)
			selector.set_pos(position)
			
		if painting and event.x < OS.get_video_mode_size().x - 136:
			self.paint(selector_position)
	
func _ready():
	init_gui()
	pass


