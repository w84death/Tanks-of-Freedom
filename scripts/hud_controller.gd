
var root_node
var action_controller
var active_map

var hud_root

var end_turn_card
var end_turn_button
var end_turn_button_red

var hud_unit_card
var hud_unit
var hud_unit_life
var hud_unit_attack
var hud_unit_ap
var hud_unit_plain
var hud_unit_road
var hud_unit_river
var hud_unit_icon
var hud_unit_progress_ap
var hud_unit_progress_ap_blank
var hud_unit_progress_attack
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
var hud_in_game_card_text
var hud_in_game_card_player_blue_turn
var hud_in_game_card_player_red_turn
var hud_in_game_card_button

var zoom_card
var zoom_in_button
var zoom_out_button

var menu_button

var player_ap
var turn_card
var turn_counter

var end_game
var blue_wins
var red_wins
var win_missions_button
var win_restart_button

func init_root(root, action_controller_object, hud):
	root_node = root
	action_controller = action_controller_object
	hud_root = hud

	active_map = root.scale_root

	end_turn_card = hud.get_node("turn_card")
	end_turn_button = end_turn_card.get_node("end_turn")
	end_turn_button_red = end_turn_card.get_node("end_turn_red")
	turn_counter = end_turn_card.get_node("turn_no")
	end_turn_button.connect("pressed", action_controller, "end_turn")
	end_turn_button_red.connect("pressed", action_controller, "end_turn")
	

	player_ap = end_turn_card.get_node("Label")
	turn_card = hud.get_node("game_card")
	

	end_game = hud.get_node("end_game")
	blue_wins = hud.get_node("end_game/blue_win")
	red_wins = hud.get_node("end_game/red_win")
	win_missions_button = end_game.get_node("buttons/select_mission")
	win_missions_button.connect("pressed", root, "show_missions")
	win_restart_button = end_game.get_node("buttons/restart")
	win_restart_button.connect("pressed", root, "restart_map")

	hud_unit_card = hud.get_node("bottom_center")
	hud_unit = hud_unit_card.get_node("unit_card")
	hud_unit_life = hud_unit.get_node("life")
	hud_unit_attack = hud_unit.get_node("attack")
	hud_unit_ap = hud_unit.get_node("action_points")
	hud_unit_plain = hud_unit.get_node("plain")
	hud_unit_road = hud_unit.get_node("road")
	hud_unit_river = hud_unit.get_node("river")
	hud_unit_icon = hud_unit.get_node("unit_icon")
	hud_unit_progress_ap = hud_unit.get_node("progress_ap")
	hud_unit_progress_ap_blank = hud_unit.get_node("progress_ap_blank")
	hud_unit_progress_attack = hud_unit.get_node("progress_attack")
	hud_unit_shield = hud_unit.get_node("shield")
	hud_unit_details_toggle = hud_unit.get_node("details_toggle")
	hud_unit_details_toggle_label = hud_unit_details_toggle.get_node("Label")
	hud_unit_details_toggle.connect("pressed", action_controller, "toggle_unit_details_view")
	
	hud_building = hud.get_node("bottom_center/building_card")
	hud_building_icon = hud_building.get_node("building_icon")
	hud_building_label = hud_building.get_node("name")
	hud_building_spawn_button = hud_building.get_node("buy")
	hud_building_unit_icon = hud_building.get_node("unit_icon")
	hud_building_cost = hud_building.get_node("unit_cost")
	hud_building_spawn_button.connect("pressed", action_controller, "spawn_unit_from_active_building")

	hud_in_game_card = hud.get_node("in_game_card")
	hud_in_game_card_body = hud_in_game_card.get_node("center")
	hud_in_game_card_text = hud_in_game_card_body.get_node("text")
	hud_in_game_card_player_blue_turn = hud_in_game_card_body.get_node("blue_player")
	hud_in_game_card_player_red_turn = hud_in_game_card_body.get_node("red_player")
	hud_in_game_card_button = hud_in_game_card_body.get_node("button")
	hud_in_game_card_button.connect("pressed", action_controller, "in_game_menu_pressed")

	zoom_card = hud.get_node("zoom_card")
	zoom_in_button = zoom_card.get_node("zoom_in")
	zoom_out_button = zoom_card.get_node("zoom_out")
	zoom_in_button.connect("pressed", action_controller, "camera_zoom_in")
	zoom_out_button.connect("pressed", action_controller, "camera_zoom_out")
	
	menu_button = hud.get_node("game_card/escape")
	menu_button.connect("pressed", root, "toggle_menu")

func show_unit_card(unit, player):
	self.update_unit_card(unit)
	self.set_unit_card_icon(unit)
	self.show_hud_unit(player)

func update_unit_card(unit):
	var stats = unit.get_stats()
	hud_unit_life.set_text(str(stats.life))
	hud_unit_attack.set_text(str(stats.attack))
	hud_unit_ap.set_text(str(stats.ap))
	sync_ap_progress(stats.ap)
	hud_unit_plain.set_text(str(stats.plain))
	hud_unit_road.set_text(str(stats.road))
	hud_unit_river.set_text(str(stats.river))
	hud_unit_progress_attack.set_frame(stats.attacks_number)
	if unit.can_defend():
		hud_unit_shield.show()
	else:
		hud_unit_shield.hide()

func set_unit_card_icon(unit):
	hud_unit_icon.set_region_rect(Rect2((unit.player + 1) * 32, unit.type * 32, 32, 32))

func clear_unit_card():
	hud_unit.hide()

func sync_ap_progress(ap):
	if ap > 8:
		ap = 8
	hud_unit_progress_ap_blank.set_frame(ap)
	hud_unit_progress_ap.set_frame(ap)

func mark_potential_ap_usage(active, required_ap):
	if active == null || active.object == null || active.object.group != 'unit':
		return
	if hud_unit_progress_ap == null:
		return
	
	var ap_left = active.object.ap - required_ap
	if ap_left < 0:
		ap_left = 0
	if ap_left > 8:
		ap_left = 8
	hud_unit_progress_ap.set_frame(ap_left)
	
func set_ap_progress(ap):
	if ap > 8:
		ap = 8
	hud_unit_progress_ap.set_frame(ap)

func show_building_card(building):
	if not building.can_spawn:
		return
	
	hud_building_icon.set_region_rect(building.get_region_rect())
	hud_building_unit_icon.set_region_rect(building.get_region_rect())
	hud_building_label.set_text(building.get_building_name())
	hud_building_cost.set_text(str(building.get_cost()))
	hud_building.show()

func clear_building_card():
	hud_building.hide()

func show_in_game_card(messages, current_player):
	active_map.hide()
	end_turn_button.set_disabled(true)
	end_turn_button_red.set_disabled(true)
	end_turn_card.hide()
	end_game.hide()
	
	turn_card.hide()
	self.clear_building_card()
	self.clear_unit_card()
	if current_player == 1:
		hud_in_game_card_player_blue_turn.hide()
		hud_in_game_card_player_red_turn.show()
	else:
		hud_in_game_card_player_blue_turn.show()
		hud_in_game_card_player_red_turn.hide()
	hud_in_game_card_text.clear()
	for message in messages:
		hud_in_game_card_text.add_text(message)
		hud_in_game_card_text.newline()
		hud_in_game_card_text.newline()
	hud_in_game_card.show()

func close_in_game_card():
	end_turn_button.set_disabled(false)
	end_turn_button_red.set_disabled(false)
	hud_in_game_card.hide()
	active_map.show()
	end_turn_card.show()
	turn_card.show()
	action_controller.move_camera_to_active_bunker()
	action_controller.show_bonus_ap()

func update_ap(ap):
	player_ap.set_text(str(ap))
	if ap>0:
		end_turn_button_red.hide()

func set_turn(no):
	turn_counter.set_text(str(no))

func warn_end_turn():
	end_turn_button_red.show()

func warn_player_ap():
	return


func show_win(player):
	end_turn_card.hide()
	self.clear_building_card()
	self.clear_unit_card()
	end_game.show();
	if player == 0:
		blue_wins.show()
		print('blue wins')
	else:
		red_wins.show()
		print('red wins')
		
func toggle_unit_details_view(player):
	hud_unit_expanded[player] = not hud_unit_expanded[player]
	self.show_hud_unit(player)
	
func show_hud_unit(player):
	var index = 0
	var margin
	var label = "SHOW\nMORE" 
		
	if hud_unit_expanded[player]:
		index = 1
		label = "SHOW\nLESS"

	hud_unit_details_toggle_label.set_text(label)
	margin = hud_unit_expanded_positions[index]
	hud_unit_card.set_margin(MARGIN_TOP,margin.top)
	hud_unit_card.set_margin(MARGIN_BOTTOM,margin.bottom)
	hud_unit.show()
	print(hud_unit_expanded_positions[index])
	
