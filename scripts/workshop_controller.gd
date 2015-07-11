
extends Control

var root
var is_working = false
var is_suspended = true

var selector = preload('res://gui/selector.xscn').instance()
var selector_position = Vector2(0,0)
var game_scale
var map_pos

var hud_file_positions = [-34,108]
var hud_file_panel
var hud_file
var hud_file_toggle_button
var hud_file_play_button
var hud_file_save_button
var hud_file_load_button
var hud_file_name
var hud_file_floppy

var hud_building_blocks
var hud_building_blocks_blocks
var building_blocks_database = [
		# name, tile id in sprite, type, blueprint id
		["EREASE", 0, "terrain", -1],
		["PLAIN", 0, "terrain", 1],
		["FOREST", 0, "terrain", 2],
		["MOUNTAINS", 0, "terrain", 3],
		["RIVER", 0, "terrain", 17],
		["BRIDGE", 0, "terrain", 18],
		["CITY", 0, "terrain", 4],
		["STATUE", 0, "terrain", 5],
		["GSM TOWER", 0, "terrain", 11],
		["FENCE", 0, "terrain", 12],
		["ROAD #1", 0, "terrain", 14],
		["ROAD #2", 0, "terrain", 15],
		["JOIN ROADS", 0, "terrain", 16],

		["HQ BLUE", 0, "terrain", 6],
		["HQ RED", 0, "terrain", 7],
		["BARRACKS", 0, "terrain", 8],
		["FACTORY", 0, "terrain", 9],
		["AIRPORT", 0, "terrain", 10],
		["SPAWN", 0, "terrain", 13],

		["INFANTRY B", 0, "units", 0],
		["TANK B", 0, "units", 1],
		["HELI B", 0, "units", 2],
		["INFANTRY R", 0, "units", 3],
		["TANK R", 0, "units", 4],
		["HELI B", 0, "units", 5]
	]
var hud_toolset_active = false

var hud_message
var hud_message_box
var hud_message_box_button
var hud_message_box_title
var hud_message_box_message

var hud_toolbox
var hud_toolbox_front

var hud_toolbox_close_button
var hud_toolbox_fill_x
var hud_toolbox_fill_y
var hud_toolbox_fill_button
var hud_toolbox_clear_terrain
var hud_toolbox_clear_units
var hud_toolbox_turn_cap
var hud_toolbox_start_ap
var hud_toolbox_start_ap_set
var hud_toolbox_win1
var hud_toolbox_win2
var hud_toolbox_win3

var hud_navigation_panel
var hud_toolbox_toggle_button
var hud_building_blocks_toggle_button

var hud_build_undo_button
var hud_build_undo_button_label

var toolbox_is_open = false

var toolset_active_page = 0
var tool_type = "terrain"
var brush_type = 1


var restore_file_name = "restore_map"

var map
var terrain
var units
var painting = false
var painting_allowed = true
var history = []
var paint_count = 0
var autosave_after = 10
var painting_motion = false

var settings = {
	fill = [4,6,8,12,16,20,24,32,48,64],
	fill_selected = [0,0],
	turn_cap = [0,25,50,75,100],
	turn_cap_selected = 0,
	win = [true,false,false]
}



const MAP_MAX_X = 64
const MAP_MAX_Y = 64
const RIGHT_DEAD_ZONE = 136
const LEFT_DEAD_ZONE = 60

func init_gui():
	hud_file = self.get_node("file_card/center")
	hud_file_panel = hud_file.get_node("file_panel")
	hud_file_floppy = hud_file_panel.get_node("controls/floppy/anim")
	hud_file_name = hud_file_panel.get_node("controls/file_name")
	hud_file_toggle_button = hud_file_panel.get_node("controls/file_button")
	hud_file_play_button = hud_file_panel.get_node("controls/play_button")
	hud_file_save_button = hud_file_panel.get_node("controls/save_button")
	hud_file_load_button = hud_file_panel.get_node("controls/load_button")

	hud_file_play_button.connect("pressed", self, "play_map")
	hud_file_save_button.connect("pressed", self, "save_map", [hud_file_name, true])
	hud_file_load_button.connect("pressed", self, "load_map", [hud_file_name, true])
	hud_file_toggle_button.connect("pressed", self, "toggle_file_panel")

	map = get_node("blueprint/center/scale/map")
	terrain = map.get_node("terrain")
	units = map.get_node("terrain/units")

	game_scale = get_node("blueprint/center/scale")

	# NAVIGATION PANEL
	hud_navigation_panel = self.get_node("navigation_panel/center/navigation_panel/controls")
	hud_toolbox_toggle_button = hud_navigation_panel.get_node("toolbox_button")
	hud_building_blocks_toggle_button = hud_navigation_panel.get_node("building_blocks_button")
	hud_build_undo_button = self.get_node("navigation_panel/center/navigation_panel/controls/undo_button")
	hud_build_undo_button_label = hud_build_undo_button.get_node("Label")

	hud_toolbox_toggle_button.connect("pressed",self,"toggle_toolbox")
	hud_building_blocks_toggle_button.connect("pressed",self,"toggle_building_blocks")

	# message
	hud_message = self.get_node("message")
	hud_message_box = hud_message.get_node("center/message")
	hud_message_box_button = hud_message_box.get_node("button")
	hud_message_box_button.connect("pressed", self, "close_message")

	# BUILDING building_blocks

	hud_building_blocks = self.get_node("building_blocks_panel")
	hud_building_blocks_blocks = hud_building_blocks.get_node("center/building_blocks")


	# toolbox

	hud_toolbox = self.get_node("toolbox_panel")
	hud_toolbox_front = hud_toolbox.get_node("center/toolbox/front/")
	hud_toolbox_close_button = hud_toolbox_front.get_node("close")

	hud_toolbox_fill_x = hud_toolbox_front.get_node("x")
	hud_toolbox_fill_y = hud_toolbox_front.get_node("y")
	hud_toolbox_fill_button = hud_toolbox_front.get_node("fill")

	hud_toolbox_fill_x.get_node('label').set_text(str(settings.fill[settings.fill_selected[0]]))
	hud_toolbox_fill_y.get_node('label').set_text(str(settings.fill[settings.fill_selected[1]]))

	hud_toolbox_clear_terrain = hud_toolbox_front.get_node("clear_terrain")
	hud_toolbox_clear_units = hud_toolbox_front.get_node("clear_units")

	hud_toolbox_turn_cap = hud_toolbox_front.get_node("turn_cap")
	hud_toolbox_start_ap = hud_toolbox_front.get_node("start_ap/ap")
	hud_toolbox_start_ap_set = hud_toolbox_front.get_node("start_ap_set")
	#hud_toolbox_win1 = hud_toolbox_front.get_node("win1")
	#hud_toolbox_win2 = hud_toolbox_front.get_node("win2")
	#hud_toolbox_win3 = hud_toolbox_front.get_node("win3")

	hud_build_undo_button.connect("pressed",self,"undo_last_action")

	hud_toolbox_fill_x.connect("pressed",self,"toggle_fill", [0,hud_toolbox_fill_x.get_node("label")])
	hud_toolbox_fill_y.connect("pressed",self,"toggle_fill", [1,hud_toolbox_fill_y.get_node("label")])
	hud_toolbox_fill_button.connect("pressed",self,"toolbox_fill")
	hud_toolbox_clear_terrain.connect("pressed",self,"toolbox_clear", [0])
	hud_toolbox_clear_units.connect("pressed",self,"toolbox_clear", [1])

	hud_toolbox_turn_cap.connect("pressed",self,"toggle_turn_cap", [hud_toolbox_turn_cap.get_node("label")])
	#hud_toolbox_win1.connect("pressed",self,"toolbox_win", [0,hud_toolbox_win1.get_node("label")])
	#hud_toolbox_win2.connect("pressed",self,"toolbox_win", [1,hud_toolbox_win2.get_node("label")])
	#hud_toolbox_win3.connect("pressed",self,"toolbox_win", [2,hud_toolbox_win3.get_node("label")])

	self.show_message("Welcome!",["This is workshop. A place to create awesome maps.","Keep in mind that this tool is still in developement and may contain nasty bugs."])

	self.load_map(restore_file_name)
	return

func add_action(params):
	var last_brush

	if params.tool_type == "terrain":
		last_brush = terrain.get_cell(params.position.x,params.position.y)

	if params.tool_type == "units":
		last_brush = units.get_cell(params.position.x,params.position.y)

	history.append({
		position = params.position,
		tool_type = params.tool_type,
		brush_type = last_brush
		})
	paint_count += 1
	if not painting_motion and paint_count >= autosave_after:
		self.save_map(restore_file_name)
		paint_count = 0

	hud_build_undo_button.set_disabled(false)
	hud_build_undo_button_label.show()

func undo_last_action():
	var last_action
	if history.size() > 0:
		last_action = history[history.size()-1]
		self.paint(last_action.position,last_action.tool_type,last_action.brush_type, true)
		history.remove(history.size()-1)
	else:
		hud_build_undo_button.set_disabled(true)
		hud_build_undo_button_label.hide()

func toolbox_win(option,label):
	settings.win[option] = not settings.win[option]
	var text = "off"
	if settings.win[option]:
		text = "on"
	label.set_text(text)
	return

func toggle_fill(axis,label):
	if settings.fill_selected[axis] < settings.fill.size()-1:
		settings.fill_selected[axis] += 1
	else:
		settings.fill_selected[axis] = 0

	label.set_text(str(settings.fill[settings.fill_selected[axis]]))
	return

func toggle_turn_cap(label):
	if settings.turn_cap_selected < settings.turn_cap.size()-1:
		settings.turn_cap_selected += 1
	else:
		settings.turn_cap_selected = 0
	self.root.settings.turns_cap = settings.turn_cap[settings.turn_cap_selected]
	label.set_text(str(settings.turn_cap[settings.turn_cap_selected]))
	return

func toolbox_fill():
	map.fill(settings.fill[settings.fill_selected[0]],settings.fill[settings.fill_selected[1]])
	self.show_message("Toolbox", ["Terrain filled. Dimmension:" + str(settings.fill[settings.fill_selected[0]]) + "x" + str(settings.fill[settings.fill_selected[1]])])
	return

func toolbox_clear(layer):
	if layer == 0:
		# clear terrain and units
		map.clear_layer(0)
		self.show_message("Toolbox", ["Terrain and units layer cleared!"])
	if layer == 1:
		map.clear_layer(1)
		self.show_message("Toolbox", ["Units layer cleared!"])
	return

func toggle_toolbox():
	toolbox_is_open = not toolbox_is_open
	if toolbox_is_open:
		hud_toolbox.show()
		self.painting_allowed = false
		# show toolbox
	else:
		hud_toolbox.hide()
		self.painting_allowed = true
		# hide toolbox
	return

func check_map_integrity():
	#var hq_red_check = false
	#var hq_blue_check = false

	#for x in range(MAP_MAX_X):
	#	for y in range(MAP_MAX_Y):
	#		if terrain.get_cell(x,y) == 6:
	#			hq_blue_check = true
	#		if terrain.get_cell(x,y) == 7:
	#			hq_red_check = true
	#	if hq_red_check and hq_blue_check:
	#		return true
	#return false
	return true

func play_map():
	self.save_map(restore_file_name)
	if self.check_map_integrity():
		self.is_working = false
		self.is_suspended = true
		root.load_map("workshop", restore_file_name)
		root.menu.hide_workshop()
		root.toggle_menu()
	else:
		self.show_message("HQ missing", ["In this map mode there need to be HQ building for each player. Blue and Red."])
	return

func save_map(name, input = false):
	if input:
		name = name.get_text()
	if map.save_map(name):
		self.show_message("Map saved", ["Success","File name: "+str(name)])
		hud_file_floppy.play("save")
	else:
		self.show_message("File error", ["Failure!","File name: "+str(name)])

func load_map(name, input = false):
	if input:
		name = name.get_text()
	if map.load_map(name):
		self.show_message("Map loaded", ["Success","File name: "+str(name)])
		hud_file_floppy.play("save")
	else:
		self.show_message("File not found", ["Failure!","File name: "+str(name)])


func select_tool(tool_type,brush_type,button):
	hud_toolset_active = button
	self.tool_type = tool_type
	self.brush_type = brush_type
	hud_toolset_active.show()
	return

func paint(position, tool_type = null,brush_type = null, undo_action = false):
	if hud_message_box.is_visible():
		return false

	if tool_type == null:
		tool_type = self.tool_type
	if brush_type == null:
		brush_type = self.brush_type


	if position.x < 0 or position.y < 0 or position.x >= MAP_MAX_X or position.y >= MAP_MAX_Y:
		return false
	else:
		if tool_type == "terrain":
			if brush_type == -1 and units.get_cell(position.x,position.y) > -1:
				if not undo_action:
					add_action({position=Vector2(position.x,position.y),tool_type="units"})
				units.set_cell(position.x,position.y,brush_type)
			else:
				if terrain.get_cell(position.x,position.y) != brush_type:
					if not undo_action:
						add_action({position=Vector2(position.x,position.y),tool_type="terrain"})
					terrain.set_cell(position.x,position.y,brush_type)

		if tool_type == "units":
			if units.get_cell(position.x,position.y) != brush_type:
				if terrain.get_cell(position.x, position.y) in [1,13,14,15,16,17,18]:
					if not undo_action:
						add_action({position=Vector2(position.x,position.y),tool_type="units"})
					units.set_cell(position.x,position.y,brush_type)
				else:
					self.show_message("Invalid field", ["Unit can be placed only on land, river and roads."])
					return false
	units.raise()
	selector.raise()
	return true

func init(root):
	self.root = root
	terrain.add_child(selector)
	map.set_default_zoom()
	game_scale.set_scale(map.scale)
	set_process_input(true)

func _input(event):
	if self.is_working && not self.is_suspended && self.painting_allowed:
		if(event.type == InputEvent.MOUSE_BUTTON):
			if (event.button_index == BUTTON_LEFT):
				if event.pressed:
					painting = true
				else:
					painting = false
					painting_motion = false

		if (event.type == InputEvent.MOUSE_MOTION):
			map_pos = terrain.get_global_pos() / Vector2(map.scale.x,map.scale.y)
			selector_position = terrain.world_to_map( Vector2((event.x/map.scale.x)-map_pos.x,(event.y/map.scale.y)-map_pos.y))
			var position = terrain.map_to_world(selector_position)
			selector.set_pos(position)
			painting_motion = true

		if painting and event.x < OS.get_video_mode_size().x - RIGHT_DEAD_ZONE and event.x > LEFT_DEAD_ZONE :
			self.paint(selector_position)

	if Input.is_action_pressed('ui_cancel'):
		self.toggle_menu()

func toggle_menu():
	if not self.is_working:
		print('skip')
		return

	if self.is_hidden():
		self.is_suspended = false
		root.menu.show_workshop()
	else:
		self.is_suspended = true
		root.menu.hide_workshop()

func show_message(title, msg):
	self.hud_message_box.show_message(title, msg)
	self.hud_message.show()

func close_message():
	self.hud_message.hide()

func toggle_file_panel():
	var panel = hud_file_panel.get_pos()
	if panel.y == hud_file_positions[0]:
		self.hud_file_panel.set_pos(Vector2(panel.x, self.hud_file_positions[1]))
	else:
		self.hud_file_panel.set_pos(Vector2(panel.x, self.hud_file_positions[0]))

func toggle_building_blocks():
	if hud_building_blocks.is_visible():
		hud_building_blocks.hide()
	else:
		hud_building_blocks.show()

func _ready():
	init_gui()
	pass


