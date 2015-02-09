
var root

var map_0_button
var map_1_button
var map_2_button
var map_3_button
var close_button

var sound_on_button
var sound_off_button
var music_on_button
var music_off_button

func _ready():
	map_0_button = get_node("control/game_controls/map_0")
	map_1_button = get_node("control/game_controls/map_1")
	map_2_button = get_node("control/game_controls/map_2")
	map_3_button = get_node("control/game_controls/map_3")
	close_button = get_node("control/game_controls/close")

	sound_on_button = get_node("control/settings_controls/sound_on")
	sound_off_button = get_node("control/settings_controls/sound_off")
	music_on_button = get_node("control/settings_controls/music_on")
	music_off_button = get_node("control/settings_controls/music_off")

	map_0_button.connect("pressed", self, "load_small_map")
	map_1_button.connect("pressed", self, "load_large_map")
	close_button.connect("pressed", root, "toggle_menu")
	sound_on_button.connect("pressed", self, "enable_sound")
	sound_off_button.connect("pressed", self, "disable_sound")
	music_on_button.connect("pressed", self, "enable_music")
	music_off_button.connect("pressed", self, "disable_music")

func load_small_map():
	root.load_map(root.map_template_0)
	root.toggle_menu()

func load_large_map():
	root.load_map(root.map_template_1)
	root.toggle_menu()

func enable_sound():
	root.sound_settings['sound_enabled'] = true

func disable_sound():
	root.sound_settings['sound_enabled'] = false

func enable_music():
	root.sound_settings['music_enabled'] = true
	root.sound_controller.play_soundtrack()

func disable_music():
	root.sound_settings['music_enabled'] = false
	root.sound_controller.stop_soundtrack()

func init_root(root_node):
	root = root_node
