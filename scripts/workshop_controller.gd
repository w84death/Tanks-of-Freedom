
extends Control

var root

var hud_file
var hud_file_play_button
var hud_file_save_button
var hud_file_load_button
var hud_file_name

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

func play_map():
	map.save_map("temp_map")
	self.hide()
	root.load_map("workshop", "temp_map")
	return

func save_map():
	map.save_map(hud_file_name.get_text())

func load_map():
	map.load_map(hud_file_name.get_text())

func init(root):
	self.root = root

func _ready():
	init_gui()
	pass


