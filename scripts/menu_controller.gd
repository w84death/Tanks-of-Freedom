
var root
var control_node

var cpu_vs_cpu_button
var human_vs_cpu_button
var human_vs_human_button
var close_button

var maps_sub_menu = preload("res://gui/menu_maps.xscn").instance()
var maps_tutorial_button
var maps_forest_button
var maps_city_button
var maps_airport_button
var maps_big_city_button
var maps_close_button

var sound_toggle_button
var music_toggle_button
var shake_toggle_button

var sound_toggle_label
var music_toggle_label
var shake_toggle_label

var next_game_mode

func _ready():
	control_node = get_node("control")

	cpu_vs_cpu_button = get_node("control/game_controls/cpu_cpu")
	human_vs_cpu_button = get_node("control/game_controls/1p_cpu")
	human_vs_human_button = get_node("control/game_controls/1p_2p")
	close_button = get_node("control/game_controls/close")

	sound_toggle_button = get_node("control/settings_controls/sound_toggle")
	music_toggle_button = get_node("control/settings_controls/music_toggle")
	shake_toggle_button = get_node("control/settings_controls/shake_toggle")

	sound_toggle_label = sound_toggle_button.get_node("Label")
	music_toggle_label = music_toggle_button.get_node("Label")
	shake_toggle_label = shake_toggle_button.get_node("Label")

	cpu_vs_cpu_button.connect("pressed", self, "start_demo_game")
	human_vs_cpu_button.connect("pressed", self, "start_single_player_game")
	human_vs_human_button.connect("pressed", self, "start_multi_player_game")

	sound_toggle_button.connect("pressed", self, "toggle_sound")
	music_toggle_button.connect("pressed", self, "toggle_music")
	shake_toggle_button.connect("pressed", self, "toggle_shake")

	close_button.connect("pressed", root, "toggle_menu")
	self.refresh_buttons_labels()
	self.load_maps_menu()

func load_maps_menu():
	maps_sub_menu.hide()
	self.add_child(maps_sub_menu)

	maps_tutorial_button = maps_sub_menu.get_node("control/menu_controls/tutorial")
	maps_forest_button = maps_sub_menu.get_node("control/menu_controls/forest")
	maps_city_button = maps_sub_menu.get_node("control/menu_controls/city")
	maps_airport_button = maps_sub_menu.get_node("control/menu_controls/airport")
	maps_big_city_button = maps_sub_menu.get_node("control/menu_controls/big_city")
	maps_close_button = maps_sub_menu.get_node("control/menu_controls/close")

	maps_close_button.connect("pressed", self, "hide_maps_menu")

func show_maps_menu():
	control_node.hide()
	maps_sub_menu.show()

func hide_maps_menu():
	control_node.show()
	maps_sub_menu.hide()
	
func start_demo_game():
	next_game_mode = 'demo'
	self.show_maps_menu()
	
func start_single_player_game():
	next_game_mode = 'single'
	self.show_maps_menu()
	
func start_multi_player_game():
	next_game_mode = 'multi'
	self.show_maps_menu()

func load_map(name):
	if next_game_mode == 'single':
		root.settings['cpu_0'] = false
		root.settings['cpu_1'] = true
	if next_game_mode == 'multi':
		root.settings['cpu_0'] = false
		root.settings['cpu_1'] = false
	if next_game_mode == 'demo':
		root.settings['cpu_0'] = true
		root.settings['cpu_1'] = true
		
	root.load_map(name)
	root.toggle_menu()
	self.hide_maps_menu()

func toggle_sound():
	root.settings['sound_enabled'] = not root.settings['sound_enabled']
	self.refresh_buttons_labels()

func toggle_music():
	root.settings['music_enabled'] = not root.settings['music_enabled']
	if root.settings['music_enabled']:
		root.sound_controller.play_soundtrack()
	else:
		root.sound_controller.stop_soundtrack()
	self.refresh_buttons_labels()

func toggle_shake():
	root.settings['shake_enabled'] = not root.settings['shake_enabled']
	if root.settings['shake_enabled']:
		shake_toggle_label.set_text("ON")
	else:
		shake_toggle_label.set_text("OFF")

func refresh_buttons_labels():
	if root.settings['sound_enabled']:
		sound_toggle_label.set_text("ON")
	else:
		sound_toggle_label.set_text("OFF")
	if root.settings['music_enabled']:
		music_toggle_label.set_text("ON")
	else:
		music_toggle_label.set_text("OFF")
	if root.settings['shake_enabled']:
		shake_toggle_label.set_text("ON")
	else:
		shake_toggle_label.set_text("OFF")

func init_root(root_node):
	root = root_node
