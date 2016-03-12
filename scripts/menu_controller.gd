
var root
var control_nodes

var play_button
var close_button
var close_button_label
var demo_button
var quit_button

var main_menu_animations
var settings_animations
var main_menu
var settings
var menu_button
var settings_button
var campaign_button

var label_completed
var label_wins
var label_maps_created
var label_version

var maps_sub_menu = preload("res://gui/menu_maps.xscn").instance()
var maps_sub_menu_anchor
var maps_close_button
var workshop_button
var workshop

var sound_toggle_button
var music_toggle_button
var shake_toggle_button
var camera_follow_button
var camera_zoom_in_button
var camera_zoom_out_button
var resolution_button
var difficulty_button

var sound_toggle_label
var music_toggle_label
var shake_toggle_label
var camera_follow_label
var camera_zoom_label
var resolution_label
var difficulty_label

var background_map
var root_tree
var background_gradient

func _ready():
	self.control_nodes = [self.get_node("top"),self.get_node("middle"),self.get_node("bottom")]

	workshop_button = get_node("bottom/center/workshop")
	campaign_button = get_node("bottom/center/start_campaign")
	self.background_gradient = self.get_node('vigette/center/sprite')

	play_button = get_node("bottom/center/play")
	close_button = get_node("top/center/close")
	quit_button = get_node("top/center/quit")
	demo_button = get_node("bottom/center/demo")

	close_button_label = close_button.get_node('Label')

	main_menu = get_node("middle/center/game_panel")
	settings = get_node("middle/center/settings_panel")
	main_menu_animations = get_node("middle/center/menu_anim")
	settings_animations = get_node("middle/center/settings_anim")

	menu_button = get_node("top/center/main_menu")
	settings_button = get_node("top/center/settings")

	sound_toggle_button = settings.get_node("sound_toggle")
	music_toggle_button = settings.get_node("music_toggle")
	shake_toggle_button = settings.get_node("shake_toggle")
	camera_follow_button = settings.get_node("camera_follow")
	camera_zoom_in_button = settings.get_node("camera_zoom_in")
	camera_zoom_out_button = settings.get_node("camera_zoom_out")
	resolution_button = settings.get_node("display_mode_toggle")
	difficulty_button = settings.get_node("difficulty_mode_toggle")

	sound_toggle_label = sound_toggle_button.get_node("Label")
	music_toggle_label = music_toggle_button.get_node("Label")
	shake_toggle_label = shake_toggle_button.get_node("Label")
	camera_follow_label = camera_follow_button.get_node("Label")
	camera_zoom_label = settings.get_node("camera_zoom_level")
	resolution_label = resolution_button.get_node("Label")
	difficulty_label = difficulty_button.get_node("Label")

	campaign_button.connect("pressed", self, "_campaign_button_pressed")
	workshop_button.connect("pressed", self, "_workshop_button_pressed")
	play_button.connect("pressed", self, "_play_button_pressed")

	sound_toggle_button.connect("pressed", self, "_toggle_sound_button_pressed")
	music_toggle_button.connect("pressed", self, "_toggle_music_button_pressed")
	shake_toggle_button.connect("pressed", self, "_toggle_shake_button_pressed")
	camera_follow_button.connect("pressed", self, "_toggle_follow_button_pressed")
	camera_zoom_in_button.connect("pressed", self, "_camera_zoom_in_button_pressed")
	camera_zoom_out_button.connect("pressed", self, "_camera_zoom_out_button_pressed")
	resolution_button.connect("pressed", self, "_resolution_button_pressed")
	difficulty_button.connect("pressed", self, "_difficulty_button_pressed")

	close_button.connect("pressed", self, "_close_button_pressed")
	quit_button.connect("pressed", self, "_quit_button_pressed")
	menu_button.connect("pressed", self, "_menu_button_pressed")
	settings_button.connect("pressed", self, "_settings_button_pressed")
	demo_button.connect("pressed", self, "_demo_button_pressed")

	self.label_completed = self.get_node("bottom/center/completed")
	self.label_maps_created = self.get_node("bottom/center/maps_created")
	self.label_version = self.get_node("middle/center/game_panel/under_logo/copy")

	self.refresh_buttons_labels()
	self.load_maps_menu()
	self.load_workshop()

	self.update_progress_labels()
	self.update_version_label()
	self.update_zoom_label()
	self.load_background_map()
	self.toggle_main_menu()

	if self.root.settings['resolution'] == self.root.bag.resolution.UNLOCKED:
		self.background_gradient.set_scale(Vector2(7,7))

func _campaign_button_pressed():
	self.root.sound_controller.play('menu')
	self.show_campaign_menu()
func _workshop_button_pressed():
	self.root.sound_controller.play('menu')
	self.enter_workshop()
func _play_button_pressed():
	self.root.sound_controller.play('menu')
	self.show_maps_menu()
func _toggle_sound_button_pressed():
	self.toggle_sound()
	self.root.sound_controller.play('menu')
func _toggle_music_button_pressed():
	self.root.sound_controller.play('menu')
	self.toggle_music()
func _toggle_shake_button_pressed():
	self.root.sound_controller.play('menu')
	self.toggle_shake()
func _toggle_follow_button_pressed():
	self.root.sound_controller.play('menu')
	self.toggle_follow()
func _camera_zoom_in_button_pressed():
	self.root.sound_controller.play('menu')
	self.root.dependency_container.camera.camera_zoom_in()
func _camera_zoom_out_button_pressed():
	self.root.sound_controller.play('menu')
	self.root.dependency_container.camera.camera_zoom_out()
func _close_button_pressed():
	self.root.sound_controller.play('menu')
	if not self.root.is_map_loaded:
		self.root.dependency_container.saving.load_state()
	self.root.toggle_menu()
func _quit_button_pressed():
	self.root.sound_controller.play('menu')
	self.quit_game()
func _menu_button_pressed():
	self.root.sound_controller.play('menu')
	self.toggle_main_menu()
func _settings_button_pressed():
	self.root.sound_controller.play('menu')
	self.toggle_settings()
func _demo_button_pressed():
	self.root.sound_controller.play('menu')
	self.start_demo_mode()
func _maps_close_button_pressed():
	self.root.sound_controller.play('menu')
	self.hide_maps_menu()
	self.play_button.grab_focus()
func _resolution_button_pressed():
	self.root.sound_controller.play('menu')
	self.root.dependency_container.resolution.toggle_resolution()
	self.refresh_buttons_labels()
func _difficulty_button_pressed():
	self.root.sound_controller.play('menu')
	self.root.settings['easy_mode'] = not self.root.settings['easy_mode']
	self.refresh_buttons_labels()
	self.root.write_settings_to_file()


func start_demo_mode():
	self.root.dependency_container.demo_mode.start_demo_mode(false)

func load_maps_menu():
	maps_sub_menu.hide()
	self.add_child(maps_sub_menu)

	maps_sub_menu_anchor = maps_sub_menu.get_node("middle")
	maps_close_button = maps_sub_menu.get_node("bottom/control/menu_controls/close")

	maps_close_button.connect("pressed", self, "_maps_close_button_pressed")

func show_campaign_menu():
	self.root.dependency_container.controllers.campaign_menu_controller.show_campaign_menu()
	self.hide_control_nodes()
	self.root.dependency_container.controllers.campaign_menu_controller.start_button.grab_focus()

func show_maps_menu():
	self.hide_control_nodes()
	self.root.dependency_container.map_picker.attach_panel(self.maps_sub_menu_anchor)
	self.root.dependency_container.map_picker.connect(self, "switch_to_skirmish_setup_panel")
	self.root.dependency_container.map_picker.lock_delete_mode_button()
	self.maps_sub_menu.show()
	if self.root.dependency_container.map_picker.blocks_cache.size() > 0:
		self.root.dependency_container.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()
	else:
		self.maps_close_button.grab_focus()

func switch_to_skirmish_setup_panel(selected_map_name):
	self.root.dependency_container.map_picker.detach_panel()
	self.root.dependency_container.skirmish_setup.attach_panel(self.maps_sub_menu_anchor)
	self.root.dependency_container.skirmish_setup.set_map_name(selected_map_name, selected_map_name)
	self.root.dependency_container.skirmish_setup.connect(self, "switch_to_map_selection_panel", "play_selected_skirmish_map")
	self.root.dependency_container.skirmish_setup.play_button.grab_focus()

func switch_to_map_selection_panel():
	self.root.dependency_container.map_picker.attach_panel(self.maps_sub_menu_anchor)
	self.root.dependency_container.map_picker.connect(self, "switch_to_skirmish_setup_panel")
	self.root.dependency_container.skirmish_setup.detach_panel()
	self.root.dependency_container.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()

func play_selected_skirmish_map(map_name):
	self.load_map(map_name, true)

func show_control_nodes():
	for nod in self.control_nodes:
		nod.show()

func hide_control_nodes():
	for nod in self.control_nodes:
		nod.hide()

func hide_maps_menu():
	self.show_control_nodes()
	maps_sub_menu.hide()
	self.root.dependency_container.map_picker.detach_panel()
	self.root.dependency_container.skirmish_setup.detach_panel()

# MAIN MENU
func get_main_menu_visibility():
	return self.main_menu.get_opacity() == 1

func toggle_main_menu():
	if self.get_main_menu_visibility():
		self.hide_main_menu()
	else:
		if self.get_settings_visibility():
			self.hide_settings()
		self.show_main_menu()

func show_main_menu(force = false):
	if force and self.get_settings_visibility():
		self.hide_settings()
	self.main_menu_animations.play('show_main_menu')

func hide_main_menu():
	self.main_menu_animations.play('hide_main_menu')

# SETTINGS
func get_settings_visibility():
	return settings.get_pos().y == 0

func toggle_settings():
	if self.get_settings_visibility():
		self.hide_settings()
		self.show_main_menu()
	else:
		if self.get_main_menu_visibility():
			self.hide_main_menu()
		self.show_settings()
		# here we coudl back to the game (if user clicked settings in game)

func show_settings(force = false):
	if force and self.get_main_menu_visibility():
		self.hide_main_menu()
	self.refresh_buttons_labels()
	self.settings_animations.play('show_settings')

func hide_settings():
	self.settings_animations.play('hide_settings')

func manage_close_button():
	if self.root.is_map_loaded:
		self.close_button.show()
		self.close_button_label.set_text('< GAME')
	elif self.root.dependency_container.saving.is_save_available():
		self.close_button.show()
		self.close_button_label.set_text('< RESUME')
	else:
    	self.close_button.hide()

# WORKSHOP
func load_workshop():
	self.workshop = self.root.dependency_container.workshop

func enter_workshop():
	self.root.unload_map()
	self.workshop.is_working = true
	self.workshop.is_suspended = false
	self.show_workshop()

func show_workshop():
	self.hide()
	self.root.toggle_menu()
	self.workshop.show()
	self.workshop.units.raise()
	self.hide_background_map()
	self.workshop.camera.make_current()
	self.root.dependency_container.controllers.workshop_gui_controller.navigation_panel.block_button.grab_focus()

func hide_workshop():
	self.workshop.hide()
	self.workshop.camera.clear_current()
	self.root.dependency_container.camera.camera.make_current()
	self.show()
	if not self.root.is_map_loaded:
		self.show_background_map()
	self.workshop_button.grab_focus()

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

func resume_map():
	self.root.dependency_container.saving.load_state()
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

func toggle_follow():
	root.settings['camera_follow'] = not root.settings['camera_follow']
	if root.settings['camera_follow']:
		camera_follow_label.set_text("ON")
	else:
		camera_follow_label.set_text("OFF")
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
	if root.settings['camera_follow']:
		camera_follow_label.set_text("ON")
	else:
		camera_follow_label.set_text("OFF")
	if root.settings['easy_mode']:
		difficulty_label.set_text('EASY')
	else:
		difficulty_label.set_text('NORMAL')

	if root.dependency_container.resolution.override_resolution:
		self.resolution_button.set_disabled(false)
		self.resolution_label.show()
		if root.settings['resolution'] == root.dependency_container.resolution.UNLOCKED:
			resolution_label.set_text('ON')
		else:
			resolution_label.set_text('OFF')
	else:
		self.resolution_button.set_disabled(true)
		self.resolution_label.hide()

func quit_game():
	OS.get_main_loop().quit()

func update_zoom_label():
	self.camera_zoom_label.set_text(str(self.root.camera.get_camera_zoom().x))

func update_progress_labels():
	self.update_custom_maps_count_label()
	self.update_campaign_progress_label()

func update_custom_maps_count_label():
	var maps_created = self.root.dependency_container.map_list.maps.size()
	self.label_maps_created.set_text("MAPS CREATED: " + str(maps_created))

func update_campaign_progress_label():
	var completed_maps = self.root.dependency_container.campaign.get_completed_map_count()
	var total_maps = self.root.dependency_container.campaign.maps.size()
	self.label_completed.set_text("COMPLETED: " + str(completed_maps) + "/" + str(total_maps))

func update_version_label():
	self.label_version.set_text(self.root.version_name)

func init_root(root_node):
	root = root_node
	self.root_tree = self.root.get_tree()

func load_background_map():
	self.background_map = self.root.map_template.instance()
	self.background_map.is_dead = true
	self.background_map.get_node('terrain').set_tileset(self.root.main_tileset)
	self.background_map.fill_map_from_data_array(self.root.dependency_container.menu_background_map.map_data)
	self.background_map.show_blueprint = false
	self.background_map.get_node('fog_of_war').hide()
	self.root.scale_root.add_child(self.background_map)
	self.flush_group("units")
	self.flush_group("buildings")
	self.flush_group("terrain")
	self.update_background_scale()

func flush_group(name):
	var collection = self.root_tree.get_nodes_in_group(name)
	for entity in collection:
		entity.remove_from_group(name)

func show_background_map():
	if self.background_map != null:
		self.background_map.show()

func hide_background_map():
	if self.background_map != null:
		self.background_map.hide()

func update_background_scale():
	if self.background_map != null:
		self.background_map.scale = self.root.scale_root.get_scale()
		self.root.camera.set_pos(Vector2(-200, 500))

