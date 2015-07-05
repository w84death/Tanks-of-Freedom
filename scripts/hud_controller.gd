var root_node
var action_controller
var active_map

var hud_root
var hud_panel_anchor

var hud_message_card
var hud_message_card_player_blue_turn
var hud_message_card_player_red_turn
var hud_message_card_button

var hourglasses_card

var menu_button

var game_card

var hud_end_game
var hud_end_game_controls
var hud_end_game_total_turns
var hud_end_game_total_time
var hud_end_game_stats_blue
var hud_end_game_stats_red
var hud_end_game_missions_button
var hud_end_game_restart_button
var hud_end_game_menu_button

var hud_locked = false

func init_root(root, action_controller_object, hud):
	self.root_node = root
	self.action_controller = action_controller_object
	self.hud_root = hud
	self.attach_hud_panel()

	self.active_map = root.scale_root

	self.game_card = hud.get_node("top_panel/center/game_card")

	#
	# HUD END GAME
	#
	hud_end_game = hud.get_node("end_game")
	hud_end_game_controls = hud_end_game.get_node("control/controls")
	hud_end_game_total_turns = hud_end_game_controls.get_node("labels/total_turns")
	hud_end_game_total_time = hud_end_game_controls.get_node("labels/total_time")
	hud_end_game_stats_blue = hud_end_game_controls.get_node("blue")
	hud_end_game_stats_red = hud_end_game_controls.get_node("red")
	hud_end_game_missions_button = hud_end_game_controls.get_node("campaign")
	hud_end_game_restart_button = hud_end_game_controls.get_node("restart")
	hud_end_game_menu_button = hud_end_game_controls.get_node("menu")

	hud_end_game_missions_button.connect("pressed", root, "show_missions")
	hud_end_game_restart_button.connect("pressed", root, "restart_map")
	hud_end_game_menu_button.connect("pressed", root, "toggle_menu")

	#
	# MESSAGE
	#

	hud_message_card = hud.get_node("message_card")
	hud_message_card_player_blue_turn = hud_message_card.get_node("center/blue")
	hud_message_card_player_red_turn = hud_message_card.get_node("center/red")
	hud_message_card_button = hud_message_card.get_node("center/message/button")
	hud_message_card_button.connect("pressed", self, "close_message_card")

	#
	# HOUR GLASSES
	#
	hourglasses_card = hud.get_node("hourglasses")

	self.menu_button = hud.get_node("top_panel/center/game_card/escape")
	self.menu_button.connect("pressed", root, "toggle_menu")

func attach_hud_panel():
	self.hud_panel_anchor = self.hud_root.get_node('bottom_panel/center')
	self.hud_panel_anchor.add_child(self.root_node.dependency_container.controllers.hud_panel_controller.hud_panel)
	self.root_node.dependency_container.controllers.hud_panel_controller.info_panel.bind_end_turn(self.action_controller, 'end_turn')

func show_unit_card(unit, player):
	if self.hud_locked:
		return
	self.root_node.dependency_container.controllers.hud_panel_controller.show_unit_panel(unit)

func update_unit_card(unit):
	self.root_node.dependency_container.controllers.hud_panel_controller.unit_panel.update_hud()

func clear_unit_card():
	self.root_node.dependency_container.controllers.hud_panel_controller.hide_unit_panel()

func show_building_card(building, player_ap):
	if not building.can_spawn || self.hud_locked:
		return
	self.root_node.dependency_container.controllers.hud_panel_controller.show_building_panel(building, player_ap)
	self.root_node.dependency_container.controllers.hud_panel_controller.building_panel.bind_spawn_unit(self.action_controller, "spawn_unit_from_active_building")

func clear_building_card():
	self.root_node.dependency_container.controllers.hud_panel_controller.hide_building_panel()

func show_in_game_card(messages, current_player):
	self.lock_hud()
	self.hide_map()
	if current_player == 1:
		hud_message_card_player_blue_turn.hide()
		hud_message_card_player_red_turn.show()
	else:
		hud_message_card_player_blue_turn.show()
		hud_message_card_player_red_turn.hide()

	hud_message_card.show()

func close_message_card():
	hud_message_card.hide()
	self.unlock_hud()
	self.show_map()
	action_controller.move_camera_to_active_bunker()
	action_controller.show_bonus_ap()

func lock_hud():
	self.hud_locked = true
	self.root_node.dependency_container.controllers.hud_panel_controller.hide_panel()
	self.root_node.dependency_container.controllers.hud_panel_controller.clear_panels()

func unlock_hud():
	self.hud_locked = false
	self.root_node.dependency_container.controllers.hud_panel_controller.show_panel()

func update_ap(ap):
	self.root_node.dependency_container.controllers.hud_panel_controller.info_panel.set_ap(ap)

func set_turn(no):
	self.root_node.dependency_container.controllers.hud_panel_controller.info_panel.set_turn(no, self.root_node.settings['turns_cap'])

func warn_end_turn():
	return

func show_win(player, stats, turns):
	self.lock_hud()
	self.hide_map()
	self.game_card.hide()
	self.fill_end_game_stats(stats,turns)
	self.hud_end_game.show()

func show_map():
	self.active_map.show()

func hide_map():
	self.active_map.hide()

func fill_end_game_stats(stats,turns):
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
	hud_end_game_total_time.set_text(stats["time_total"])

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

func show_hourglasses():
	self.hourglasses_card.show()

func hide_hourglasses():
	self.hourglasses_card.hide()
