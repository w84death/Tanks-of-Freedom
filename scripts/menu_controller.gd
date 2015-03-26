
var root
var control_node

var tutorial_button
var red_player_button
var red_player_button_label
var blue_player_button
var blue_player_button_label
var play_button
var close_button
var quit_button

var maps_sub_menu = preload("res://gui/menu_maps.xscn").instance()
var maps_1_button
var maps_2_button
var maps_3_button
var maps_4_button
var maps_5_button
var maps_6_button
var maps_close_button
var maps_turns_cap
var maps_turns_cap_label

var tutorial_sub_menu = preload("res://gui/tutorial.xscn").instance()
var tutorial_close_button

var sound_toggle_button
var music_toggle_button
var shake_toggle_button

var sound_toggle_label
var music_toggle_label
var shake_toggle_label

func _ready():
	control_node = get_node("control")

	tutorial_button = get_node("control/game_controls/tutorial")
	blue_player_button = get_node("control/game_controls/blue_player")
	blue_player_button_label = blue_player_button.get_node("Label")
	red_player_button = get_node("control/game_controls/red_player")
	red_player_button_label = red_player_button.get_node("Label")
	play_button = get_node("control/game_controls/play")
	close_button = get_node("control/game_controls/close")
	quit_button = get_node("control/game_controls/quit")

	sound_toggle_button = get_node("control/settings_controls/sound_toggle")
	music_toggle_button = get_node("control/settings_controls/music_toggle")
	shake_toggle_button = get_node("control/settings_controls/shake_toggle")

	sound_toggle_label = sound_toggle_button.get_node("Label")
	music_toggle_label = music_toggle_button.get_node("Label")
	shake_toggle_label = shake_toggle_button.get_node("Label")

	tutorial_button.connect("pressed", self, "show_tutorial")
	blue_player_button.connect("pressed", self, "toggle_player", [0])
	red_player_button.connect("pressed", self, "toggle_player", [1])
	play_button.connect("pressed", self, "show_maps_menu")

	sound_toggle_button.connect("pressed", self, "toggle_sound")
	music_toggle_button.connect("pressed", self, "toggle_music")
	shake_toggle_button.connect("pressed", self, "toggle_shake")

	close_button.connect("pressed", root, "toggle_menu")
	quit_button.connect("pressed", self, "quit_game")
	self.refresh_buttons_labels()
	self.load_maps_menu()
	self.load_tutorial()

func load_maps_menu():
	maps_sub_menu.hide()
	self.add_child(maps_sub_menu)

	maps_1_button = maps_sub_menu.get_node("control/menu_controls/map_1")
	maps_2_button = maps_sub_menu.get_node("control/menu_controls/map_2")
	maps_3_button = maps_sub_menu.get_node("control/menu_controls/map_3")
	maps_4_button = maps_sub_menu.get_node("control/menu_controls/map_4")
	maps_5_button = maps_sub_menu.get_node("control/menu_controls/map_5")
	maps_6_button = maps_sub_menu.get_node("control/menu_controls/map_6")
	maps_close_button = maps_sub_menu.get_node("control/menu_controls/close")
	maps_turns_cap = maps_sub_menu.get_node("control/menu_controls/turns_cap")
	maps_turns_cap_label = maps_turns_cap.get_node("Label")
	
	maps_1_button.connect("pressed", self, "load_map", ["map_1"])
	maps_2_button.connect("pressed", self, "load_map", ["map_2"])
	maps_3_button.connect("pressed", self, "load_map", ["map_3"])
	maps_4_button.connect("pressed", self, "load_map", ["map_4"])
	maps_5_button.connect("pressed", self, "load_map", ["map_6"])
	maps_6_button.connect("pressed", self, "load_map", ["map_5"])
	maps_close_button.connect("pressed", self, "hide_maps_menu")
	maps_turns_cap.connect("pressed", self, "toggle_turns_cap")

func show_maps_menu():
	control_node.hide()
	maps_sub_menu.show()

func hide_maps_menu():
	control_node.show()
	maps_sub_menu.hide()

func load_tutorial():
	tutorial_sub_menu.hide()
	self.add_child(tutorial_sub_menu)

	tutorial_close_button = tutorial_sub_menu.get_node("control/menu_controls/close")
	tutorial_close_button.connect("pressed", self, "hide_tutorial")

func show_tutorial():
	control_node.hide()
	tutorial_sub_menu.show()

func hide_tutorial():
	tutorial_sub_menu.hide()
	control_node.show()

func toggle_player(player):
	root.settings['cpu_' + str(player)] = not root.settings['cpu_' + str(player)]
	var label
	if root.settings['cpu_' + str(player)]:
		label = "CPU"
	else:
		label = "Human"
		
	if player == 0:
		blue_player_button_label.set_text(label)
	else:
		red_player_button_label.set_text(label)
	
func load_map(name):
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
		
func quit_game():
	OS.get_main_loop().quit()
	
func toggle_turns_cap():
	var turns_cap_modifer = 25
	var turns_cap = root.settings['turns_cap']
	
	if turns_cap < 100:
		root.settings['turns_cap'] = turns_cap + turns_cap_modifer
	else:
		root.settings['turns_cap'] = 0
	
	if turns_cap > 0:
		maps_turns_cap_label.set_text(str(turns_cap))
	else:
		maps_turns_cap_label.set_text("OFF")

func init_root(root_node):
	root = root_node
