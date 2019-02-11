extends Control

var version_name = "Version 0.7.1-ALPHA"
var version_short = "0.7.1"

var selector = preload('res://gui/selector.xscn').instance()
var selector_position
var current_map_terrain
var camera_pos
var game_scale
var scale_root
var loading_container
var camera
var menu
var hud_pandora = preload('res://gui/hud_pandora.tscn')
var hud_tv = preload('res://gui/hud_tv.tscn')
var hud_pc = preload('res://gui/hud_pc.tscn')
var hud_template
var screen_size
var half_screen_size = Vector2(0, 0)

var intro = preload('res://intro.xscn').instance()
var loading_screen = preload('res://gui/loading.xscn').instance()

var action_controller
var sound_controller = preload("sound_controller.gd").new()
var hud_controller
var current_map
var current_map_name
var hud
var bag

var map_template = preload('res://maps/workshop.xscn')
var main_tileset

var settings = {
    'is_ok' : true,
    'sound_enabled' : true,
    'music_enabled' : true,
    'shake_enabled' : true,
    'cpu_0' : false,
    'cpu_1' : true,
    'turns_cap': 0,
    'camera_follow': true,
    'camera_move_to_bunker': true,
    'music_volume': 0.5,
    'sound_volume': 0.2,
    'camera_zoom': 2,
    'resolution': 0,
    'easy_mode' : false,
    'online_player_id' : null,
    'online_player_pin' : null,
    'is_overscan' : false,
    'language' : 'en',
    'ENV' : 'dev',
    'seen_gamepad' : false,
    'ai_speed': 1,
    "camera_move_to_bunker": true,
    "camera_speed": 1,
    "tooltips_enabled" : true,
}

var is_map_loaded = false
var is_intro = true
var is_demo = false
var is_paused = false
var is_locked_for_cpu = false
var is_from_workshop = false
var is_camera_drag = false
var settings_file = File.new()
var workshop_file_name
var is_remote = false
var is_pandora = Globals.get("tof/pandora_input")
var is_mobile = Globals.get("tof/mobile_prompt")
var is_debug = Globals.get("tof/debug_mode")
var click_fix_position = Globals.get("tof/selector_offset")
var hud_layout = Globals.get("tof/hud_layout")

var registered_click = false
var registered_click_position = Vector2(0, 0)
var registered_click_threshold = 10

const SETTINGS_PATH = "user://settings.tof"

func _input(event):
    if self.is_debug and self.is_mobile:
        print("ToF.DEBUG: ", event)

    if is_demo == true:
        is_demo = false
        get_node("DemoTimer").stop()

    if is_map_loaded && is_paused == false:
        if is_locked_for_cpu == false or self.bag.match_state.is_multiplayer:
            game_scale = self.camera.get_scale()
            camera_pos = self.camera.get_pos()
            if event.type == InputEvent.MOUSE_BUTTON && (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT) && self.is_map_loaded:
                self.is_camera_drag = event.pressed
                self.bag.camera.mouse_dragging = event.pressed
            if (event.type == InputEvent.MOUSE_MOTION or event.type == InputEvent.MOUSE_BUTTON):
                var new_selector_x = (event.x - self.half_screen_size.x + camera_pos.x/game_scale.x) * (game_scale.x)
                var new_selector_y = (event.y - self.half_screen_size.y + camera_pos.y/game_scale.y) * (game_scale.y) + 5
                selector_position = current_map_terrain.world_to_map(Vector2(new_selector_x, new_selector_y))
            if (event.type == InputEvent.MOUSE_MOTION):
                var position = current_map_terrain.map_to_world(selector_position)
                position.y += 4
                selector.set_pos(position)
                if self.is_camera_drag:
                    camera_pos.x = camera_pos.x - event.relative_x * game_scale.x
                    camera_pos.y = camera_pos.y - event.relative_y * game_scale.y
                    self.camera.set_pos(camera_pos)

        if is_locked_for_cpu == false:
            if event.type == InputEvent.JOYSTICK_BUTTON or event.type == InputEvent.JOYSTICK_MOTION:
                self.bag.gamepad.handle_input(event)
            if self.is_pandora and event.type == InputEvent.KEY:
                self.bag.pandora.handle_input(event)


            if (event.type == InputEvent.MOUSE_MOTION):
                var position = current_map_terrain.map_to_world(selector_position)
                position.y += 4
                selector.set_pos(position)
                if self.registered_click and abs(event.x - self.registered_click_position.x) > self.registered_click_threshold and abs(event.y - self.registered_click_position.y) > self.registered_click_threshold:
                    self.registered_click = false

            # MOUSE SELECT
            if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
                if not self.bag.hud_dead_zone.is_dead_zone(event.x, event.y):
                    var position = current_map_terrain.map_to_world(selector_position)
                    if not self.bag.hud_dead_zone.is_dead_zone(event.x, event.y):
                        if event.is_pressed():
                            self.registered_click = true
                            self.registered_click_position = Vector2(event.x, event.y)
                        else:
                            if self.registered_click:
                                action_controller.handle_action(selector_position)
                                self.registered_click = false

        if event.type == InputEvent.KEY && event.scancode == KEY_H && event.pressed:
            if hud.is_visible():
                hud.hide()
            else:
                hud.show()

        if event.type == InputEvent.KEY && event.scancode == KEY_C && event.pressed:
            action_controller.switch_unit(self.bag.unit_switcher.NEXT)
        if event.type == InputEvent.KEY && event.scancode == KEY_X && event.pressed:
            action_controller.switch_unit(self.bag.unit_switcher.BACK)
        if event.type == InputEvent.KEY && event.scancode == KEY_B && event.pressed:
            self.bag.camera.move_to_map_center()
        if self.is_debug:
            if event.type == InputEvent.KEY && event.scancode == KEY_F && event.pressed:
                self.bag.fog_controller.toggle_fog()
            if event.type == InputEvent.KEY && event.scancode == KEY_V && event.pressed:
                print(current_map_terrain.world_to_map(current_map_terrain.map_to_world(selector_position)))


        if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_WHEEL_UP && event.pressed:
            self.bag.camera.camera_zoom_in()
        if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_WHEEL_DOWN && event.pressed:
            self.bag.camera.camera_zoom_out()

    if Input.is_action_pressed('ui_cancel') && (event.type != InputEvent.KEY || not event.is_echo()):
        if is_map_loaded and action_controller.active_field != null:
            action_controller.clear_active_field()
        else:
            self.toggle_menu('menu', false)

func move_selector_to_map_position(pos):
    if pos.x < 0 or pos.y < 0 or pos.x > self.bag.abstract_map.MAP_MAX_X or pos.y > self.bag.abstract_map.MAP_MAX_Y:
        return

    var position = current_map_terrain.map_to_world(pos)
    position.y += 4
    selector.set_pos(position)
    selector_position = pos

func load_map(template_name, workshop_file_name = false, load_saved_state = false, is_remote = false, post_load_object = null, post_load_method = null):
    self.unload_map()
    self.bag.controllers.background_map_controller.hide_background_map()
    self.menu.hide()
    self.add_child(self.loading_screen)
    self.bag.timers.set_timeout(0.5, self, "load_map_deferred", [template_name, workshop_file_name, load_saved_state, is_remote, post_load_object, post_load_method])

func load_map_deferred(args):
    self.menu.show()
    self.remove_child(self.loading_screen)
    self.load_map_for_real(args[0], args[1], args[2], args[3], args[4], args[5])

func load_map_for_real(template_name, workshop_file_name = false, load_saved_state = false, is_remote = false, post_load_object = null, post_load_method = null):
    var human_player = 'cpu_0'
    current_map_name = template_name
    current_map = map_template.instance()
    current_map._init_bag(self.bag)
    current_map.get_node('terrain').set_tileset(self.bag.tileset_handler.available_tilesets[self.main_tileset])

    # current_map.campaign = bag.campaign
    self.workshop_file_name = workshop_file_name
    self.is_remote = is_remote
    if workshop_file_name:
        self.is_from_workshop = true
        current_map.load_map(workshop_file_name, is_remote)
        self.bag.controllers.hud_panel_controller.info_panel.set_map_name(workshop_file_name)
    else:
        var campaign_tileset = self.bag.campaign.get_map_tileset(template_name)
        current_map.switch_to_tileset(campaign_tileset)
        human_player = 'cpu_' + str(self.bag.campaign.get_map_player(template_name))
        self.is_from_workshop = false
        self.settings['cpu_0'] = true
        self.settings['cpu_1'] = true
        self.settings[human_player] = false
        self.settings['turns_cap'] = 0
        current_map.load_campaign_map(template_name)
        self.bag.controllers.hud_panel_controller.info_panel.set_map_name(self.bag.campaign.get_map_name(template_name))
    current_map.show_blueprint = false
    if self.settings['is_overscan']:
        hud = self.hud_tv.instance()
    else:
        hud = hud_template.instance()
    self.bag.gamepad.show_gamepad_icons()

    current_map_terrain = current_map.get_node("terrain")
    current_map_terrain.add_child(selector)

    scale_root.add_child(current_map)
    menu.raise()
    self.add_child(hud)

    if load_saved_state && self.bag.saving != null:
        self.bag.saving.load_map_state()

    game_scale = self.bag.camera.scale
    action_controller = self.bag.controllers.action_controller
    action_controller.init_root(self, current_map, hud)
    hud_controller = action_controller.hud_controller
    self.bag.ai.pathfinder.prepare_map_grid(self.bag.abstract_map)
    if load_saved_state && self.bag.saving != null:
        self.bag.saving.apply_saved_ground()

    self.bag.match_state.reset()
    if not workshop_file_name:
        self.bag.match_state.set_campaign_map(template_name)
        self.bag.storyteller.load_map_story(self.bag.campaign.get_map_stories(template_name))
        if not load_saved_state:
            self.bag.storyteller.mark_actors()

    if load_saved_state && self.bag.saving != null:
        self.bag.saving.apply_saved_buildings()
        self.bag.saving.apply_saved_environment_settings()
        action_controller.switch_to_player(self.bag.saving.get_active_player_id(), false)
        human_player = self.bag.saving.get_active_player_key()
        action_controller.refresh_hud()
    else:
        if workshop_file_name:
            action_controller.switch_to_player(0, false)
        else:
            action_controller.switch_to_player(self.bag.campaign.get_map_player(template_name), false)

    hud_controller.show_map()
    self.selector.init(self)
    self.is_map_loaded = true
    if menu:
        menu.manage_close_button()

    if settings[human_player]:
        self.lock_for_cpu()
    else:
        self.unlock_for_player()
        self.move_selector_to_map_position(self.bag.positions.get_player_bunker_position(self.action_controller.current_player))
    self.sound_controller.play_soundtrack()
    self.bag.language.reload_labels()
    self.bag.ai.reset()
    # preparing map
    self.bag.positions.refresh()
    self.bag.waypoint_factory.prepare_for_map()
    self.bag.positions.get_waypoints()

    if post_load_object != null:
        self.bag.timers.set_timeout(0.1, post_load_object, post_load_method)

func restart_map():
    self.load_map(current_map_name, workshop_file_name, false, self.is_remote, self, "post_restart_map")

func post_restart_map():
    self.menu.hide()

func unload_map():
    if is_map_loaded == false:
        return

    is_map_loaded = false
    self.bag.perform.stop_ai_timer()
    self.bag.storyteller.clear_stories()
    if action_controller.active_indicator.is_inside_tree():
        action_controller.active_indicator.get_parent().remove_child(action_controller.active_indicator)
    current_map_terrain.remove_child(selector)
    scale_root.remove_child(current_map)
    current_map.call_deferred("free")
    current_map = null
    current_map_terrain = null
    self.hud_controller.disable_back_to_workshop()
    self.hud_controller.detach_hud_panel()
    self.remove_child(hud)
    hud.call_deferred("free")
    hud = null
    selector.reset()
    hud_controller = null
    action_controller = null
    self.bag.controllers.background_map_controller.show_background_map()
    self.menu.manage_close_button()
    self.sound_controller.play_soundtrack()
    self.bag.camera.reset_player_cameras()

func toggle_menu(target = 'menu', skip_back_check = true):
	if self.bag.workshop.is_working and not self.bag.workshop.is_suspended:
		return

	if not skip_back_check and self.bag.menu_back.perform_back():
		return

	if is_map_loaded:
		if menu.is_hidden():
			is_paused = true
			action_controller.stats_set_time()
			menu.show()
			if target == 'menu':
				self.menu.hide_settings()
			if target == 'settings':
				self.menu.show_settings()
			hud.hide()
			menu.close_button.grab_focus()
		else:
			is_paused = false
			action_controller.stats_start_time()
			menu.hide()
			hud.show()
			if hud_controller.hud_message_card_visible:
				hud_controller.hud_message_card_button.grab_focus()
			if action_controller.game_ended:
				hud_controller.hud_end_game_missions_button.grab_focus()

func show_menu():
	if self.is_map_loaded and self.menu.is_hidden():
		self.toggle_menu()

func hide_menu():
    if self.menu.is_visible():
        self.toggle_menu()

func show_missions():
	self.toggle_menu()
	menu.show_maps_menu()

func show_campaign():
	self.toggle_menu()
	self.bag.controllers.campaign_menu_controller.show_campaign_menu()

func load_menu():
	menu.show()
	is_intro = false
	self.remove_child(intro)
	intro.call_deferred("free")
	self.add_child(menu)
	menu.manage_close_button()
	self.bag.resolution.refresh_menu_background()
	self.bag.timers.set_timeout(0.1, menu.campaign_button, "grab_focus")
	self.sound_controller.play_soundtrack()
	self.bag.language.reload_labels()
	set_process_input(true)

func lock_for_cpu():
	self.is_locked_for_cpu = true
	self.hud_controller.lock_hud()
	self.selector.hide()
	if self.settings['cpu_0'] * self.settings['cpu_1'] == 0:
		self.camera.camera_follow = false
		if not self.bag.match_state.is_multiplayer:
			self.hud_controller.switch_cinematic_to_cpu_meter()
		else:
			self.hud_controller.switch_cinematic_to_multiplayer()
		self.hud_controller.show_cinematic_camera()
	else:
		self.hud_controller.hide_cinematic_camera()

func unlock_for_player():
	self.is_locked_for_cpu = false
	self.hud_controller.unlock_hud()
	self.selector.show()
	self.camera.camera_follow = true
	self.hud_controller.hide_cinematic_camera()

func lock_for_demo():
	is_demo = true
	self.lock_for_cpu()

func unlock_for_demo():
	is_demo = false

func is_demo_mode():
	return self.is_demo or (self.settings['cpu_0'] and self.settings['cpu_1'])

func read_settings_from_file():
	var data = self.bag.file_handler.read(self.SETTINGS_PATH)
	if data.empty():
		self.bag.file_handler.write(self.SETTINGS_PATH, self.settings)
	else:
		for option in data:
			self.settings[option] = data[option]

func write_settings_to_file():
	self.bag.file_handler.write(self.SETTINGS_PATH, self.settings)

func _ready():
	self.bag = preload('res://scripts/services/dependency_container.gd').new()
	self.scale_root = get_node("/root/game/viewport/pixel_scale")
	self.read_settings_from_file()
	TranslationServer.set_locale(self.settings['language'])
	if self.hud_layout == "overscan":
		self.hud_template = self.hud_tv
	elif self.hud_layout == "pandora":
		self.hud_template = self.hud_pandora
	else:
		self.hud_template = self.hud_pc
	self.bag.init_root(self)
	self.main_tileset = self.bag.tileset_handler.get_current_tileset()
	self.camera = self.bag.camera
	self.menu = self.bag.controllers.menu_controller
	self.sound_controller.init_root(self)
	menu.init_root(self)
	menu.hide()
	intro.init_root(self)
	self.add_child(intro)
	self.bag.language.reload_labels()
	if self.is_mobile:
		self.get_tree().set_auto_accept_quit(false)