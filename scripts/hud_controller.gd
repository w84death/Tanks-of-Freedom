
var root_node
var action_controller
var active_map

var hud_root

var hud_game_card
var hud_turn_button
var hud_turn_button_red
var hud_turn_button_red_anim

var hud_unit_card
var hud_unit
var hud_unit_life
var hud_unit_attack
var hud_unit_ap
var hud_unit_shield
var hud_unit_details_toggle
var hud_unit_details_toggle_label
var hud_unit_expanded = [false,false]
var hud_unit_expanded_positions = [
	{'top':42,'bottom':42},
	{'top':100,'bottom':100}]
var hud_building
var hud_building_spawn_button
var hud_building_icon
var hud_building_unit_icon
var hud_building_label
var hud_building_cost

var hud_in_game_card
var hud_in_game_card_body
var hud_in_game_card_player_blue_turn
var hud_in_game_card_player_red_turn
var hud_in_game_card_button

var hud_story_card
var hud_story_card_text
var hud_story_card_button

var zoom_card
var zoom_in_button
var zoom_out_button

var hourglasses_card

var menu_button

var player_ap
var game_card
var turn_counter
var total_time_counter
var time_blue_counter
var time_red_counter
var turns_limit

var hud_end_game
var hud_end_game_controls
var hud_end_game_total_turns
var hud_end_game_total_time
var hud_end_game_stats_blue
var hud_end_game_stats_red
var hud_end_game_missions_button
var hud_end_game_restart_button
var hud_end_game_menu_button

func init_root(root, action_controller_object, hud):
	root_node = root
	action_controller = action_controller_object
	hud_root = hud

	active_map = root.scale_root

	#
	# HUD GAME CARD
	#
	hud_game_card = hud.get_node("top_center/turn_card")
	hud_turn_button = hud_game_card.get_node("end_turn")
	hud_turn_button_red = hud_game_card.get_node("end_turn_red")
	hud_turn_button_red_anim = hud_turn_button_red.get_node("anim")
	turn_counter = hud_game_card.get_node("turn_no")
	total_time_counter = hud_game_card.get_node("total_time")
	time_blue_counter = hud_game_card.get_node("time_blue")
	time_red_counter = hud_game_card.get_node("time_red")
	turns_limit = hud_game_card.get_node("limit")
	hud_turn_button.connect("pressed", action_controller, "end_turn")
	hud_turn_button_red.connect("pressed", action_controller, "end_turn")

	var limit = self.root_node.settings.turns_cap
	if limit == 0:
		limit = "OFF"
	turns_limit.set_text("LIMIT: "+str(limit))

	player_ap = hud_game_card.get_node("Label")
	game_card = hud.get_node("game_card")

	#
	# HUD END GAME
	#
	hud_end_game = hud.get_node("end_game")
	hud_end_game_controls = hud_end_game.get_node("control/controls")
	hud_end_game_total_turns = hud_end_game_controls.get_node("labels/total_turns")
	hud_end_game_total_time = hud_end_game_controls.get_node("labels/total_time")
	hud_end_game_stats_blue = hud_end_game_controls.get_node("blue")
	hud_end_game_stats_red = hud_end_game_controls.get_node("red")
	hud_end_game_missions_button = hud_end_game_controls.get_node("select_mission")
	hud_end_game_restart_button = hud_end_game_controls.get_node("restart")
	hud_end_game_menu_button = hud_end_game_controls.get_node("menu")

	hud_end_game_missions_button.connect("pressed", root, "show_missions")
	hud_end_game_restart_button.connect("pressed", root, "restart_map")
	hud_end_game_menu_button.connect("pressed", root, "toggle_menu")

	#
	# HUD UNIT CARD
	#
	hud_unit_card = hud.get_node("left_panel")
	hud_unit = hud_unit_card.get_node("unit_card")
	hud_unit_life = hud_unit.get_node("controls/life")
	hud_unit_attack = hud_unit.get_node("controls/attack")
	hud_unit_ap = hud_unit.get_node("controls/action_points")
	hud_unit_shield = hud_unit.get_node("controls/shield")

	#
	# HUD BUILDING
	#
	hud_building = hud.get_node("left_panel/building_card")
	hud_building_icon = hud_building.get_node("building_icon")
	hud_building_label = hud_building.get_node("name")
	hud_building_spawn_button = hud_building.get_node("buy")
	hud_building_unit_icon = hud_building.get_node("unit_icon")
	hud_building_cost = hud_building.get_node("unit_cost")
	hud_building_spawn_button.connect("pressed", action_controller, "spawn_unit_from_active_building")

	#
	# HUD IN GAME CARD
	#
	hud_in_game_card = hud.get_node("in_game_card")
	hud_in_game_card_body = hud_in_game_card.get_node("center")
	hud_in_game_card_player_blue_turn = hud_in_game_card_body.get_node("blue")
	hud_in_game_card_player_red_turn = hud_in_game_card_body.get_node("red")
	hud_in_game_card_button = hud_in_game_card_body.get_node("button")
	hud_in_game_card_button.connect("pressed", action_controller, "in_game_menu_pressed")

	hud_story_card = hud.get_node("briefing_card")
	hud_story_card_text = hud_story_card.get_node("center/content")
	hud_story_card_button = hud_story_card.get_node("center/button")
	hud_story_card_button.connect("pressed", self, "close_story_card")

	#
	# HUD ZOOM CARD
	#
	zoom_card = hud.get_node("zoom_card")
	zoom_in_button = zoom_card.get_node("zoom_in")
	zoom_out_button = zoom_card.get_node("zoom_out")
	zoom_in_button.connect("pressed", action_controller, "camera_zoom_in")
	zoom_out_button.connect("pressed", action_controller, "camera_zoom_out")
	
	#
	# HOUR GLASSES
	#
	hourglasses_card = hud.get_node("hourglasses")

	menu_button = hud.get_node("game_card/escape")
	menu_button.connect("pressed", root, "toggle_menu")
	
func show_unit_card(unit, player):
	self.update_unit_card(unit)
	self.show_hud_unit(player)

func update_unit_card(unit):
	var stats = unit.get_stats()
	hud_unit_life.set_text(str(stats.life))
	hud_unit_attack.set_text(str(stats.attack))

	if unit.can_defend():
		hud_unit_shield.show()
	else:
		hud_unit_shield.hide()

func clear_unit_card():
	hud_unit.hide()

func mark_potential_ap_usage(active, required_ap):
	return

func show_building_card(building, player_ap):
	if not building.can_spawn:
		return

	hud_building_icon.set_region_rect(building.get_region_rect())
	hud_building_unit_icon.set_region_rect(building.get_region_rect())
	hud_building_label.set_text(building.get_building_name())
	hud_building_cost.set_text(str(building.get_cost()))
	if player_ap >= building.get_cost():
		hud_building_spawn_button.set_disabled(false)
	else:
		hud_building_spawn_button.set_disabled(true)
	hud_building.show()

func clear_building_card():
	hud_building.hide()

func show_in_game_card(messages, current_player):
	self.lock_hud()
	if current_player == 1:
		hud_in_game_card_player_blue_turn.hide()
		hud_in_game_card_player_red_turn.show()
	else:
		hud_in_game_card_player_blue_turn.show()
		hud_in_game_card_player_red_turn.hide()

	hud_in_game_card.show()

func close_in_game_card():
	hud_in_game_card.hide()
	self.unlock_hud()
	action_controller.move_camera_to_active_bunker()
	action_controller.show_bonus_ap()

func show_story_card(message):
	self.lock_hud()
	hud_story_card_text.set_text(message)
	hud_story_card.show()

func close_story_card():
	hud_story_card.hide()
	self.unlock_hud()

func lock_hud():
	active_map.hide()
	hud_turn_button.set_disabled(true)
	hud_turn_button_red.set_disabled(true)
	hud_game_card.hide()
	hud_end_game.hide()
	zoom_card.hide()
	game_card.hide()
	self.clear_building_card()
	self.clear_unit_card()

func unlock_hud():
	hud_turn_button.set_disabled(false)
	hud_turn_button_red.set_disabled(false)
	active_map.show()
	hud_game_card.show()
	game_card.show()
	zoom_card.show()

func update_ap(ap):
	player_ap.set_text(str(ap))
	if ap>0:
		hud_turn_button_red.hide()
		#hud_turn_button_red_anim.stop()
		hud_turn_button.show()

func set_turn(no):
	turn_counter.set_text(str(no))

func warn_end_turn():
	hud_turn_button.hide()
	hud_turn_button_red.show()
	hud_turn_button_red_anim.play()

func warn_player_ap():
	return

func show_win(player,stats,turns):
	hud_game_card.hide()
	self.clear_building_card()
	self.clear_unit_card()
	active_map.hide()
	hud_turn_button.set_disabled(true)
	hud_turn_button_red.set_disabled(true)
	hud_game_card.hide()
	zoom_card.hide()
	game_card.hide()
	self.fill_end_game_stats(stats,turns)
	hud_end_game.show()

func show_map():
	active_map.show()

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

func toggle_unit_details_view(player):
	hud_unit_expanded[player] = not hud_unit_expanded[player]
	self.show_hud_unit(player)

func show_hud_unit(player):
	hud_unit.show()

func show_hourglasses():
	hourglasses_card.show()

func hide_hourglasses():
	hourglasses_card.hide()
