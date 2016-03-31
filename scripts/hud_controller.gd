var root
var action_controller
var active_map

var hud_root
var hud_panel_anchor

var hud_message_card
var hud_message_card_controller
var hud_message_card_button
var hud_message_card_visible = false


var cinematic_camera
var cinematic_camera_anim
var cinematic_progress
var menu_button
var menu_button_label
var settings_button

var game_card
var hud_vigette

var hud_end_game
var hud_end_game_controls
var hud_end_game_total_turns
var hud_end_game_total_time
var hud_end_game_stats_blue
var hud_end_game_stats_red
var hud_end_game_missions_button
var hud_end_game_missions_button_label
var hud_end_game_restart_button
var hud_end_game_menu_button
var hud_end_game_missions_button_action

var hud_locked = false
var back_to_workshop = false
var tips

var tip_counter

func init_root(root, action_controller_object, hud):
    self.root = root
    self.action_controller = action_controller_object
    self.hud_root = hud
    self.attach_hud_panel()
    self.tip_counter = 1
    self.tips = preload('res://scripts/translations/tips.gd').new()

    self.active_map = root.scale_root

    self.game_card = hud.get_node("top_panel/center/game_card")

    hud_vigette = hud.get_node("vigette/center/sprite")

    if self.root.settings['resolution'] == self.root.bag.resolution.UNLOCKED:
        hud_vigette.set_scale(Vector2(7,7))

    #
    # HUD END GAME
    #
    hud_end_game = hud.get_node("end_game")
    hud_end_game_controls = hud_end_game.get_node("center/controls")
    hud_end_game_total_turns = hud_end_game_controls.get_node("labels/total_turns")
    hud_end_game_total_time = hud_end_game_controls.get_node("labels/total_time")
    hud_end_game_stats_blue = hud_end_game_controls.get_node("blue")
    hud_end_game_stats_red = hud_end_game_controls.get_node("red")
    hud_end_game_missions_button = hud_end_game_controls.get_node("campaign")
    hud_end_game_missions_button_label = hud_end_game_missions_button.get_node("Label")
    hud_end_game_restart_button = hud_end_game_controls.get_node("restart")
    hud_end_game_menu_button = hud_end_game_controls.get_node("menu")

    hud_end_game_missions_button.connect("pressed", self, "hud_end_game_missions_button_pressed")
    hud_end_game_restart_button.connect("pressed", self, "_hud_end_game_restart_button_pressed")
    hud_end_game_menu_button.connect("pressed", self, "_hud_end_game_menu_button_pressed")

    #
    # MESSAGE
    #

    hud_message_card = hud.get_node("message_card")
    hud_message_card_controller = hud_message_card.get_node("center/message")
    hud_message_card_button = hud_message_card.get_node("center/message/button")
    hud_message_card_button.connect("pressed", self, "_hud_message_card_button_pressed")

    #
    # CPU TURN
    #
    cinematic_camera = hud.get_node("cinematic_camera")
    cinematic_camera_anim = cinematic_camera.get_node("anim")
    cinematic_progress = cinematic_camera.get_node("bottom/bottom_block/progress")

    self.menu_button = hud.get_node("top_panel/center/game_card/menu")
    self.menu_button_label = self.menu_button.get_node('Label')
    self.settings_button = hud.get_node("top_panel/center/game_card/settings")
    self.menu_button.connect("pressed", self, "_menu_button_pressed", ['menu'])
    self.settings_button.connect("pressed", self, "_menu_button_pressed", ['settings'])
    self.root.bag.controllers.hud_panel_controller.reset()

func _hud_end_game_restart_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.restart_map()
func _hud_end_game_menu_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.toggle_menu()
    self.root.unload_map()
    self.root.bag.timers.set_timeout(0.1, self.root.menu.campaign_button, "grab_focus")
func _hud_message_card_button_pressed():
    self.root.sound_controller.play('menu')
    self.close_message_card()
func _menu_button_pressed(tab):
    self.root.sound_controller.play('menu')
    self.root.toggle_menu(tab)
    if self.back_to_workshop:
        self.root.bag.controllers.menu_controller.enter_workshop()
func _end_turn_button_pressed():
    self.root.sound_controller.play('menu')
    self.action_controller.end_turn()


func attach_hud_panel():
    self.hud_panel_anchor = self.hud_root.get_node('bottom_panel/center')
    self.hud_panel_anchor.add_child(self.root.bag.controllers.hud_panel_controller.hud_panel)
    self.root.bag.controllers.hud_panel_controller.info_panel.bind_end_turn(self, '_end_turn_button_pressed')

func detach_hud_panel():
    self.hud_panel_anchor.remove_child(self.root.bag.controllers.hud_panel_controller.hud_panel)

func enable_back_to_workshop():
    self.back_to_workshop = true
    self.menu_button_label.set_text("< WORKSHOP")

func disable_back_to_workshop():
    self.back_to_workshop = false
    self.menu_button_label.set_text("< MAIN MENU")

func show_unit_card(unit, player):
    if self.hud_locked:
        return
    self.root.bag.controllers.hud_panel_controller.show_unit_panel(unit)

func update_unit_card(unit):
    self.root.bag.controllers.hud_panel_controller.unit_panel.update_hud()

func clear_unit_card():
    self.root.bag.controllers.hud_panel_controller.hide_unit_panel()

func show_building_card(building, player_ap):
    if not building.can_spawn || self.hud_locked:
        return
    self.root.bag.controllers.hud_panel_controller.show_building_panel(building, player_ap)
    self.root.bag.controllers.hud_panel_controller.building_panel.bind_spawn_unit(self.action_controller, "spawn_unit_from_active_building")

func clear_building_card():
    self.root.bag.controllers.hud_panel_controller.hide_building_panel()

func show_in_game_card(messages, current_player):
    self.lock_hud()
    self.hide_map()
    hud_message_card_controller.show_message(self.__show_general_header(), self.__show_next_tip(), 'Start your turn now!', "START TURN", current_player)
    hud_message_card.show()
    hud_message_card_button.grab_focus()
    hud_message_card_visible = true


func close_message_card():
    hud_message_card.hide()
    self.unlock_hud()
    self.show_map()
    action_controller.move_camera_to_active_bunker()
    action_controller.show_bonus_ap()
    hud_message_card_visible = false

func lock_hud():
    self.hud_locked = true
    self.root.bag.controllers.hud_panel_controller.hide_panel()
    self.root.bag.controllers.hud_panel_controller.clear_panels()

func unlock_hud():
    self.hud_locked = false
    self.root.bag.controllers.hud_panel_controller.show_panel()

func update_ap(ap):
    self.root.bag.controllers.hud_panel_controller.info_panel.set_ap(ap)

func set_turn(no):
    self.root.bag.controllers.hud_panel_controller.info_panel.set_turn(no, self.root.settings['turns_cap'])

func warn_end_turn():
    self.root.bag.controllers.hud_panel_controller.info_panel.end_button_flash()

func show_win(player, stats, turns):
    self.adjust_missions_button()
    self.lock_hud()
    #self.hide_map()
    self.game_card.hide()
    self.fill_end_game_stats(stats, turns)
    self.hud_end_game.show()

func adjust_missions_button():
    if self.root.bag.match_state.is_campaign():
        self.hud_end_game_missions_button_label.set_text("CAMPAIGN")
        self.hud_end_game_missions_button_action = "show_campaign"
    elif self.root.bag.match_state.is_workshop():
        self.hud_end_game_missions_button_label.set_text("WORKSHOP")
        self.hud_end_game_missions_button_action = "show_workshop"
    else:
        self.hud_end_game_missions_button_label.set_text("SKIRMISH")
        self.hud_end_game_missions_button_action = "show_missions"

func hud_end_game_missions_button_pressed():
    self.root.sound_controller.play('menu')
    self.call(self.hud_end_game_missions_button_action)
    self.root.unload_map()

func show_campaign():
    self.root.toggle_menu()
    self.root.menu.show_campaign_menu()

func show_missions():
    self.root.toggle_menu()
    self.root.bag.controllers.menu_controller.show_maps_menu()
    self.root.bag.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()

func show_workshop():
    self.root.bag.controllers.menu_controller.enter_workshop()
    self.root.bag.controllers.workshop_gui_controller.file_panel.play_button.grab_focus()

func show_map():
    self.active_map.show()

func hide_map():
    self.active_map.hide()

func fill_end_game_stats(stats, turns):
    #var total_turns = hud_end_game_controls.get_node("total_turns")
    var blue_domination = hud_end_game_stats_blue.get_node("domination")
    var blue_moves = hud_end_game_stats_blue.get_node("unit_moves")
    var blue_turn_time = hud_end_game_stats_blue.get_node("turn_time")
    var blue_kills = hud_end_game_stats_blue.get_node("kills")
    var blue_spawns = hud_end_game_stats_blue.get_node("spawn_count")
    var blue_score = hud_end_game_stats_blue.get_node("overall")

    var red_domination = hud_end_game_stats_red.get_node("domination")
    var red_moves = hud_end_game_stats_red.get_node("unit_moves")
    var red_turn_time = hud_end_game_stats_red.get_node("turn_time")
    var red_kills = hud_end_game_stats_red.get_node("kills")
    var red_spawns = hud_end_game_stats_red.get_node("spawn_count")
    var red_score = hud_end_game_stats_red.get_node("overall")

    hud_end_game_total_turns.set_text(str(turns))
    hud_end_game_total_time.set_text(stats["total_time"])

    blue_domination.set_text(str(stats["domination"][0]))
    blue_moves.set_text(str(stats["moves"][0]))
    blue_turn_time.set_text(str(stats["time"][0]))
    blue_kills.set_text(str(stats["kills"][0]))
    blue_spawns.set_text(str(stats["spawns"][0]))
    blue_score.set_text(str(stats["score"][0]))

    red_domination.set_text(str(stats["domination"][1]))
    red_moves.set_text(str(stats["moves"][1]))
    red_turn_time.set_text(str(stats["time"][1]))
    red_kills.set_text(str(stats["kills"][1]))
    red_spawns.set_text(str(stats["spawns"][1]))
    red_score.set_text(str(stats["score"][1]))

func show_cinematic_camera():
    self.cinematic_camera.show()
    self.cinematic_camera_anim.play("on")

func hide_cinematic_camera():
    self.cinematic_camera_anim.play("off")
    self.cinematic_camera.hide()

func update_cpu_progress(current_ap, overall_ap):
    if overall_ap == 0 || current_ap > overall_ap:
        return

    var percent = (float(current_ap) / float(overall_ap)) * 100;
    percent = int(percent)
    percent = (percent - (percent % 10)) / 10
    percent = 10 - percent
    if percent > 9:
        percent = 9
    self.cinematic_progress.set_frame(percent)

func __show_next_tip():
	self.tip_counter = (self.tip_counter + 1) % 13
	return self.tips.tips[self.tip_counter]

func __show_general_header():
	return 'Did you know that...'
