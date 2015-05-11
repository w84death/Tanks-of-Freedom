
var root
var control_node

var red_player_button
var red_player_button_label
var blue_player_button
var blue_player_button_label
var play_button
var close_button
var quit_button

var maps_sub_menu = preload("res://gui/menu_maps.xscn").instance()
var maps_play_button
var maps_play_custom_button
var maps_close_button
var maps_turns_cap
var maps_turns_cap_label
var maps_select_map
var maps_select_custom_map

var tutorial_sub_menu = preload("res://gui/tutorial.xscn").instance()
var tutorial_close_button
var tutorial_button

var workshop = preload("res://gui/workshop/workshop.xscn").instance()
var workshop_button

var sound_toggle_button
var music_toggle_button
var shake_toggle_button

var sound_toggle_label
var music_toggle_label
var shake_toggle_label

func _ready():
	control_node = get_node("control")

	tutorial_button = get_node("control/game_controls/tutorial")
	workshop_button = get_node("control/game_controls/workshop")
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
	workshop_button.connect("pressed", self, "enter_workshop")
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
	self.load_workshop()

func load_maps_menu():
	maps_sub_menu.hide()
	self.add_child(maps_sub_menu)

	maps_play_button = maps_sub_menu.get_node("control/menu_controls/play")
	maps_play_custom_button = maps_sub_menu.get_node("control/menu_controls/play_custom")
	maps_close_button = maps_sub_menu.get_node("control/menu_controls/close")
	maps_turns_cap = maps_sub_menu.get_node("control/menu_controls/turns_cap")
	maps_turns_cap_label = maps_turns_cap.get_node("Label")
	maps_select_map = maps_sub_menu.get_node("control/menu_controls/maps")
	maps_select_custom_map = maps_sub_menu.get_node("control/menu_controls/custom_maps")

	maps_select_map.add_item("border")
	maps_select_map.add_item("river")
	maps_select_map.add_item("city")
	maps_select_map.add_item("country")

	self.load_custom_maps_list(maps_select_custom_map)

	maps_play_button.connect("pressed", self, "load_map_from_list", [maps_select_map, false])
	maps_play_custom_button.connect("pressed", self, "load_map_from_list", [maps_select_custom_map, true])
	maps_close_button.connect("pressed", self, "hide_maps_menu")
	maps_turns_cap.connect("pressed", self, "toggle_turns_cap")
	maps_select_map.connect("selected",self,"load_map", [])

func load_custom_maps_list(dropdown):
	var map_list = root.dependency_container.map_list.maps

	for map in map_list:
		dropdown.add_item(map)

func refresh_custom_maps_list():
	self.maps_select_custom_map.clear()
	self.load_custom_maps_list(self.maps_select_custom_map)

func show_maps_menu():
	self.refresh_custom_maps_list()
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

func load_workshop():
	root.add_child(workshop)
	workshop.init(root)
	workshop.hide()

func enter_workshop():
	root.unload_map()
	workshop.is_working = true
	workshop.is_suspended = false
	self.show_workshop()
	workshop.raise()
	root.cursor.raise()

func show_workshop():
	control_node.hide()
	workshop.show()
	workshop.units.raise()

func hide_workshop():
	workshop.hide()
	control_node.show()

func toggle_player(player):
	root.settings['cpu_' + str(player)] = not root.settings['cpu_' + str(player)]
	self.set_player_button_state(player)

func set_player_button_state(player):
	var label
	if root.settings['cpu_' + str(player)]:
		label = "CPU"
	else:
		label = "Human"

	if player == 0:
		blue_player_button_label.set_text(label)
	else:
		red_player_button_label.set_text(label)

func reset_player_buttons():
	self.set_player_button_state(0)
	self.set_player_button_state(1)

func load_map_from_list(list, from_workshop):
	self.load_map(list.get_item_text(list.get_selected()), from_workshop)

func load_map(name, from_workshop):
	if from_workshop:
		root.load_map('workshop', name)
	else:
		root.load_map(name, false)
	root.toggle_menu()
	self.hide_maps_menu()
	workshop.hide()
	workshop.is_working = false
	workshop.is_suspended = true

func toggle_sound():
	root.settings['sound_enabled'] = not root.settings['sound_enabled']
	self.refresh_buttons_labels()
	root.write_settings_to_file()

func toggle_music():
	root.settings['music_enabled'] = not root.settings['music_enabled']
	if root.settings['music_enabled']:
		root.sound_controller.play_soundtrack()
	else:
		root.sound_controller.stop_soundtrack()
	self.refresh_buttons_labels()
	root.write_settings_to_file()

func toggle_shake():
	root.settings['shake_enabled'] = not root.settings['shake_enabled']
	if root.settings['shake_enabled']:
		shake_toggle_label.set_text("ON")
	else:
		shake_toggle_label.set_text("OFF")
	root.write_settings_to_file()

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

	if root.settings['turns_cap'] >= 100:
		root.settings['turns_cap'] = 0
	else:
		root.settings['turns_cap'] = root.settings['turns_cap'] + turns_cap_modifer
	self.adjust_turns_cap_label()

func adjust_turns_cap_label():
	if root.settings['turns_cap'] > 0:
		maps_turns_cap_label.set_text(str(root.settings['turns_cap']))
	else:
		maps_turns_cap_label.set_text("OFF")

func init_root(root_node):
	root = root_node
