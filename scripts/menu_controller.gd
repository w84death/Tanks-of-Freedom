
var root

var map_0_button
var map_1_button
var map_2_button
var map_3_button
var close_button

var sound_toggle_button
var music_toggle_button
var shake_toggle_button

var sound_toggle_label
var music_toggle_label
var shake_toggle_label

func _ready():
	map_0_button = get_node("control/game_controls/map_0")
	map_1_button = get_node("control/game_controls/map_1")
	map_2_button = get_node("control/game_controls/map_2")
	map_3_button = get_node("control/game_controls/map_3")
	close_button = get_node("control/game_controls/close")

	sound_toggle_button = get_node("control/settings_controls/sound_toggle")
	music_toggle_button = get_node("control/settings_controls/music_toggle")
	shake_toggle_button = get_node("control/settings_controls/shake_toggle")

	sound_toggle_label = sound_toggle_button.get_node("Label")
	music_toggle_label = music_toggle_button.get_node("Label")
	shake_toggle_label = shake_toggle_button.get_node("Label")
	
	map_0_button.connect("pressed", self, "load_small_map")
	map_1_button.connect("pressed", self, "load_large_map")
	sound_toggle_button.connect("pressed", self, "toggle_sound")
	music_toggle_button.connect("pressed", self, "toggle_music")
	shake_toggle_button.connect("pressed", self, "toggle_shake")
	
	close_button.connect("pressed", root, "toggle_menu")
	self.refresh_buttons_labels()

func load_small_map():
	root.load_map(root.map_template_0)
	root.toggle_menu()

func load_large_map():
	root.load_map(root.map_template_1)
	root.toggle_menu()

func toggle_sound():
	root.sound_settings['sound_enabled'] = not root.sound_settings['sound_enabled']
	self.refresh_buttons_labels()

func toggle_music():
	root.sound_settings['music_enabled'] = not root.sound_settings['music_enabled']
	if root.sound_settings['music_enabled']:
		root.sound_controller.play_soundtrack()
	else:
		root.sound_controller.stop_soundtrack()
	self.refresh_buttons_labels()

func toggle_shake():
	#implementation missing
	#remember that button is disabled in scene settings
	#if root.sound_settings['sound_enabled']:
	#	sound_toggle_label.set_text("ON")
	#else:
	#	sound_toggle_label.set_text("OFF")
	return true

func refresh_buttons_labels():
	if root.sound_settings['sound_enabled']:
		sound_toggle_label.set_text("ON")
	else:
		sound_toggle_label.set_text("OFF")
	if root.sound_settings['music_enabled']:
		music_toggle_label.set_text("ON")
	else:
		music_toggle_label.set_text("OFF")

func init_root(root_node):
	root = root_node
