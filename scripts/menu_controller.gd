
var root
var control_node

var red_player_button
var red_player_button_label
var blue_player_button
var blue_player_button_label
var play_button
var close_button
var demo_button
var quit_button

var main_menu
var settings
var menu_button
var settings_button

var campaign_button

var maps_sub_menu = preload("res://gui/menu_maps.xscn").instance()
var maps_play_custom_button
var maps_close_button
var maps_turns_cap
var maps_turns_cap_label
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
	self.control_node = self.get_node("control")

	#tutorial_button = get_node("control/game_panel/tutorial")
	workshop_button = get_node("control/workshop")

	campaign_button = get_node("control/start_campaign")

	play_button = get_node("control/play")
	close_button = get_node("control/close")
	quit_button = get_node("control/quit")
	demo_button = get_node("control/demo")

	main_menu = get_node("control/game_panel")
	settings = get_node("control/settings_panel")

	menu_button = get_node("control/main_menu")
	settings_button = get_node("control/settings")

	sound_toggle_button = get_node("control/settings_panel/sound_toggle")
	music_toggle_button = get_node("control/settings_panel/music_toggle")
	shake_toggle_button = get_node("control/settings_panel/shake_toggle")

	sound_toggle_label = sound_toggle_button.get_node("Label")
	music_toggle_label = music_toggle_button.get_node("Label")
	shake_toggle_label = shake_toggle_button.get_node("Label")

	campaign_button.connect("pressed", self, "show_campaign_menu")
	#tutorial_button.connect("pressed", self, "show_tutorial")
	workshop_button.connect("pressed", self, "enter_workshop")
	play_button.connect("pressed", self, "show_maps_menu")

	sound_toggle_button.connect("pressed", self, "toggle_sound")
	music_toggle_button.connect("pressed", self, "toggle_music")
	shake_toggle_button.connect("pressed", self, "toggle_shake")

	close_button.connect("pressed", root, "toggle_menu")
	quit_button.connect("pressed", self, "quit_game")
	menu_button.connect("pressed", self, "show_main_menu")
	settings_button.connect("pressed", self, "show_settings")
	demo_button.connect("pressed", self, "start_demo_mode")

	self.refresh_buttons_labels()
	self.load_maps_menu()
	self.load_tutorial()
	self.load_workshop()

	blue_player_button = maps_sub_menu.get_node("control/menu_controls/blue_player")
	blue_player_button_label = blue_player_button.get_node("Label")
	red_player_button = maps_sub_menu.get_node("control/menu_controls/red_player")
	red_player_button_label = red_player_button.get_node("Label")

	blue_player_button.connect("pressed", self, "toggle_player", [0])
	red_player_button.connect("pressed", self, "toggle_player", [1])

func start_demo_mode():
	print('start_demo_mode')
	self.root.dependency_container.demo_mode.start_demo_mode(false)

func load_maps_menu():
	maps_sub_menu.hide()
	self.add_child(maps_sub_menu)

	maps_play_custom_button = maps_sub_menu.get_node("control/menu_controls/play_custom")
	maps_close_button = maps_sub_menu.get_node("control/menu_controls/close")
	maps_turns_cap = maps_sub_menu.get_node("control/menu_controls/turns_cap")
	maps_turns_cap_label = maps_turns_cap.get_node("Label")
	maps_select_custom_map = maps_sub_menu.get_node("control/menu_controls/custom_maps")

	self.load_custom_maps_list(maps_select_custom_map)

	maps_play_custom_button.connect("pressed", self, "load_map_from_list", [maps_select_custom_map, true])
	maps_close_button.connect("pressed", self, "hide_maps_menu")
	maps_turns_cap.connect("pressed", self, "toggle_turns_cap")

func load_custom_maps_list(dropdown):
	var map_list = root.dependency_container.map_list.maps

	for map in map_list:
		dropdown.add_item(map)

func refresh_custom_maps_list():
	self.maps_select_custom_map.clear()
	self.load_custom_maps_list(self.maps_select_custom_map)

func show_campaign_menu():
	self.root.dependency_container.controllers.campaign_menu_controller.show_campaign_menu()
	control_node.hide()

func show_maps_menu():
	self.refresh_custom_maps_list()
	self.control_node.hide()
	self.reset_player_buttons()
	self.maps_sub_menu.show()

func hide_maps_menu():
	control_node.show()
	maps_sub_menu.hide()

func show_main_menu():
	main_menu.show()
	settings.hide()

func show_settings():
	main_menu.hide()
	settings.show()

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
	root.add_child(self.workshop)
	workshop.init(root)
	workshop.hide()

func enter_workshop():
	root.unload_map()
	workshop.is_working = true
	workshop.is_suspended = false
	self.show_workshop()

func show_workshop():
	self.hide()
	self.root.toggle_menu()
	workshop.show()
	workshop.units.raise()

func hide_workshop():
	workshop.hide()
	self.show()

func toggle_player(player):
	root.settings['cpu_' + str(player)] = not root.settings['cpu_' + str(player)]
	self.set_player_button_state(player)

func set_player_button_state(player):
	var label
	if root.settings['cpu_' + str(player)]:
		label = "CPU"
	else:
		label = "HUMAN"

	if player == 0:
		blue_player_button_label.set_text(label)
	else:
		red_player_button_label.set_text(label)

func reset_player_buttons():
	self.set_player_button_state(0)
	self.set_player_button_state(1)

func load_map_from_list(list, from_workshop):
	var map_identifier
	if from_workshop:
		map_identifier = list.get_item_text(list.get_selected())
	else:
		map_identifier = list.get_selected()
	self.load_map(map_identifier, from_workshop)

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
