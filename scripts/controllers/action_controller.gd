
var root_node
var root_tree
var ysort
var damage_layer
var selector
var active_field = null
var active_indicator = preload('res://gui/selector.xscn').instance()
var hud_controller = preload('res://scripts/hud_controller.gd').new()
var battle_stats
var sound_controller
var ai
var pathfinding
var demo_timer
var positions
var actual_movement_tiles = {}

var current_player = 0
var player_ap = [0,0]
var player_ap_max = 1
var turn = 1
var title
var camera

var game_ended = false

const BREAK_EVENT_LOOP = 1

func reset():
	self.root_tree = null
	self.ysort = null
	self.damage_layer = null
	self.selector = null
	self.active_field = null
	self.battle_stats = null
	self.sound_controller = null
	self.ai = null
	self.pathfinding = null
	self.demo_timer = null
	self.positions = null
	self.current_player = 0
	self.player_ap = [0, 0]
	self.player_ap_max = 1
	self.turn = 1
	self.title = null
	self.camera = null
	self.game_ended = false

func init_root(root, map, hud):
	self.reset()
	self.root_node = root
	self.root_tree = self.root_node.get_tree()

	self.root_node.dependency_container.abstract_map.reset()
	self.root_node.dependency_container.abstract_map.init_map(map)
	self.root_node.dependency_container.action_map.init_map(map)

	camera = root.scale_root
	ysort = map.get_node('terrain/front')
	damage_layer = map.get_node('terrain/destruction')
	selector = root.selector
	self.import_objects()
	hud_controller.init_root(root, self, hud)
	hud_controller.set_turn(turn)
	if not root_node.settings['cpu_0']:
		hud_controller.show_in_game_card([], current_player)

	self.positions = root.dependency_container.positions
	self.positions.get_player_bunker_position(current_player)
	self.positions.bootstrap()

	battle_stats = preload("res://scripts/battle_stats.gd").new()

	sound_controller = root.sound_controller

	self.root_node.dependency_container.abstract_map.create_tile_type_map()
	self.root_node.dependency_container.abstract_map.update_terrain_tile_type_map(self.positions.get_terrain_obstacles())

	pathfinding = preload('res://scripts/ai/pathfinding/a_star_pathfinding.gd').new()
	ai = preload("res://scripts/ai/ai.gd").new(self.positions, pathfinding, self.root_node.dependency_container.abstract_map, self)

	demo_timer = root_node.get_node("DemoTimer")

func set_active_field(position):
	var field = self.root_node.dependency_container.abstract_map.get_field(position)
	self.clear_active_field()
	self.activate_field(field)

	self.move_camera_to_point(field.position)

	return field

func handle_action(position):
	if game_ended:
		return

	var field = self.root_node.dependency_container.abstract_map.get_field(position)

	if field.object != null:
		if active_field != null:
			if field.object.group == 'unit' && active_field.object.group == 'unit':
				if active_field.is_adjacent(field) && field.object.player != current_player && self.has_ap():
					if (self.handle_battle(active_field, field) == BREAK_EVENT_LOOP):
						return
				else:
					sound_controller.play('no_move')

					hud_controller.update_unit_card(active_field.object)
			if active_field.object.group == 'unit' && active_field.object.type == 0 && field.object.group == 'building' && field.object.player != current_player:
				if active_field.is_adjacent(field) && self.root_node.dependency_container.movement_controller.can_move(active_field, field) && self.has_ap():
					if (self.capture_building(active_field, field) == BREAK_EVENT_LOOP):
						return
		if (field.object.group == 'unit' || (field.object.group == 'building' && field.object.can_spawn)) && field.object.player == current_player:
			self.activate_field(field)
	else:
		if active_field != null && active_field.object != null && field != active_field && field.object == null:
			#if active_field.object.group == 'unit' && active_field.is_adjacent(field) && field.terrain_type != -1 && self.has_ap():
			if active_field.object.group == 'unit'  && self.is_movement_possible(field, active_field) && field.terrain_type != -1 && self.has_ap():
				self.move_unit(active_field, field)

func post_handle_action():
	self.positions.refresh_units()

func capture_building(active_field, field):
	self.use_ap(field)

	#adding trail
	self.root_node.dependency_container.abstract_map.add_trails([active_field.object.move_positions], active_field.object.player, 2)

	field.object.claim(self.current_player, self.turn)
	sound_controller.play('occupy_building')
	self.root_node.dependency_container.ap_gain.update()
	if field.object.type == 4:
		active_field.object.takeAllAP()
	else:
		self.despawn_unit(active_field)
	self.root_node.dependency_container.abstract_map.map.fog_controller.clear_fog()
	self.activate_field(field)
	if field.object.type == 0:
		self.end_game(self.current_player)
		return 1


func activate_field(field):
	self.clear_active_field()
	active_field = field
	self.root_node.dependency_container.abstract_map.tilemap.add_child(active_indicator)
	self.root_node.dependency_container.abstract_map.tilemap.move_child(active_indicator, 0)
	var position = Vector2(self.root_node.dependency_container.abstract_map.tilemap.map_to_world(field.position))
	position.y += 2
	active_indicator.set_pos(position)
	sound_controller.play('select')
	if field.object.group == 'unit':
		hud_controller.show_unit_card(field.object, current_player)
		if not root_node.settings['cpu_' + str(current_player)]:
			self.add_movement_indicators(field)
	if field.object.group == 'building' && not root_node.settings['cpu_' + str(current_player)]:
		hud_controller.show_building_card(field.object, player_ap[current_player])

func clear_active_field():
	active_field = null
	self.root_node.dependency_container.abstract_map.tilemap.remove_child(active_indicator)
	hud_controller.clear_unit_card()
	hud_controller.clear_building_card()
	self.root_node.dependency_container.action_map.reset()

func add_movement_indicators(field):
	self.root_node.dependency_container.action_map.reset()
	if player_ap[current_player] > 0 && field.object.ap > 0:
		# calculating range
		var tiles_range = min(field.object.ap, player_ap[current_player])
		var tiles = []
		var first_action_range = ceil(field.object.ap / 2)

		var unit_moved = false
		if field.object.ap != field.object.max_ap:
			unit_moved = true

		var unit_position = field.object.get_pos_map()
		var path = []

		#TODO - move it
		var abstract_map = self.root_node.dependency_container.abstract_map
		var cost_grid = preload('res://scripts/ai/pathfinding/cost_grid.gd').new(abstract_map)

		self.pathfinding.set_cost_grid(cost_grid.prepare_cost_maps([], []))

		self.actual_movement_tiles.clear()

		for lookup in range (tiles_range, 0, -1):
			# print('lookup', lookup)
			tiles = self.root_node.dependency_container.positions.get_nearby_tiles_subset(unit_position, lookup)

			for tile in tiles:
				path = pathfinding.pathSearch(unit_position, tile, [])
				if path.size() <= tiles_range:
					self.actual_movement_tiles[tile] = path.size()
					self.root_node.dependency_container.action_map.mark_movement_tile(field, tile, first_action_range, unit_moved, current_player)



func despawn_unit(field):
	ysort.remove_child(field.object)
	field.object.queue_free()
	field.object = null

func destroy_unit(field):
	field.object.die_after_explosion(ysort)
	field.object = null

func spawn_unit_from_active_building():
	var active_object = active_field.object
	if active_field == null || active_object.group != 'building' || active_object.can_spawn == false:
		return
	var spawn_point = self.root_node.dependency_container.abstract_map.get_field(active_object.spawn_point)
	var required_ap = active_object.get_required_ap()
	if spawn_point.object == null && self.has_enough_ap(required_ap):
		var unit = active_object.spawn_unit(current_player)
		ysort.add_child(unit)
		unit.set_pos_map(spawn_point.position)
		spawn_point.object = unit
		self.deduct_ap(required_ap)
		sound_controller.play_unit_sound(unit, sound_controller.SOUND_SPAWN)
		self.activate_field(spawn_point)
		self.move_camera_to_point(spawn_point.position)

		#gather stats
		battle_stats.add_spawn(self.current_player)
		self.root_node.dependency_container.abstract_map.map.fog_controller.clear_fog()

func import_objects():
	self.attach_objects(self.root_tree.get_nodes_in_group("units"))
	self.attach_objects(self.root_tree.get_nodes_in_group("buildings"))
	self.attach_objects(self.root_tree.get_nodes_in_group("terrain"))

func attach_objects(collection):
	for entity in collection:
		self.root_node.dependency_container.abstract_map.get_field(entity.get_initial_pos()).object = entity

func end_turn():
	self.stats_set_time()
	if self.root_node.settings['turns_cap'] > 0:
		if turn >= self.root_node.settings['turns_cap']:
			self.end_game(-1)
			return

	sound_controller.play('end_turn')
	if current_player == 0:
		self.switch_to_player(1)
	else:
		self.switch_to_player(0)
		turn += 1
	hud_controller.set_turn(turn)

	#gather stats
	battle_stats.add_domination(self.current_player, self.positions.get_player_buildings(self.current_player).size())
	if turn == 1 || fmod(turn, 3) == 0:
		ai.select_behaviour_type(current_player)

func move_camera_to_active_bunker():
	var bunker_position = self.positions.get_player_bunker_position(current_player)
	if bunker_position != null:
		self.move_camera_to_point(bunker_position)

func move_camera_to_point(position):
	self.root_node.dependency_container.abstract_map.map.move_to_map(position)

func in_game_menu_pressed():
	hud_controller.close_in_game_card()

func has_ap():
	if player_ap[current_player] > 0:
		return true
	sound_controller.play('no_moves')
	return false

func has_enough_ap(ap):
	if player_ap[current_player] >= ap:
		return true
	return false

func use_ap(field):
	var position = field.position
	var cost = 1
	if self.actual_movement_tiles.has(position):
		cost = self.actual_movement_tiles[position]
	self.deduct_ap(cost)

func is_movement_possible(field, active_field):
	#TODO hack for AI
	if root_node.settings['cpu_' + str(current_player)]:
		return active_field.is_adjacent(field)

	var position = field.position
	if self.actual_movement_tiles.has(position):
		return true

	return false

func deduct_ap(ap):
	self.update_ap(player_ap[current_player] - ap)

func update_ap(ap):
	player_ap[current_player] = ap
	hud_controller.update_ap(player_ap[current_player])
	if player_ap[current_player] == 0:
		hud_controller.warn_end_turn()

func refill_ap():
	self.positions.refresh_units()
	self.positions.refresh_buildings()

	var total_ap = player_ap[current_player]
	var buildings = self.positions.get_player_buildings(current_player)
	for building in buildings:
		total_ap = total_ap + buildings[building].bonus_ap
	self.update_ap(total_ap)

func show_bonus_ap():
	var buildings = self.positions.get_player_buildings(current_player)
	for building in buildings:
		if buildings[building].bonus_ap > 0 && not self.root_node.dependency_container.abstract_map.map.fog_controller.is_fogged(buildings[building].position_on_map.x, buildings[building].position_on_map.y):
			buildings[building].show_floating_ap()

func switch_to_player(player):
	self.stats_start_time()
	self.clear_active_field()
	current_player = player
	self.reset_player_units(player)
	selector.set_player(player);
	self.root_node.dependency_container.abstract_map.map.current_player = player
	self.refill_ap()
	if root_node.settings['cpu_' + str(player)]:
		root_node.start_ai_timer()
		root_node.lock_for_cpu()
		self.move_camera_to_active_bunker()
		self.show_bonus_ap()
		self.ai.set_ap_for_turn(self.player_ap[player])
	else:
		root_node.unlock_for_player()
		hud_controller.show_in_game_card([], current_player)
		self.root_node.dependency_container.controllers.hud_panel_controller.info_panel.end_button_enable()
	self.root_node.dependency_container.abstract_map.map.fog_controller.clear_fog()
	self.root_node.dependency_container.ap_gain.update()

func perform_ai_stuff():
	var success = false
	if root_node.settings['cpu_' + str(current_player)] && player_ap[current_player] > 0:
		success = ai.gather_available_actions(player_ap[current_player])

	self.hud_controller.update_cpu_progress(player_ap[current_player], ai.ap_for_turn)

	return player_ap[current_player] > 0 && success

func reset_player_units(player):
	var units = self.root_tree.get_nodes_in_group("units")
	for unit in units:
		if unit.player == player:
			unit.reset_ap()

func end_game(winning_player):
	self.root_node.ai_timer.reset_state()
	self.clear_active_field()
	game_ended = true
	if root_node.hud.is_hidden():
		root_node.hud.show()
	hud_controller.show_win(winning_player, battle_stats.get_stats(), turn)
	selector.hide()
	if (root_node.is_demo):
		demo_timer.reset(demo_timer.STATS)
		demo_timer.start()
	if (self.root_node.dependency_container.match_state.is_campaign()) && winning_player > -1:
		if not self.root_node.settings['cpu_' + str(winning_player)]:
			var mission_num = self.root_node.dependency_container.match_state.get_map_number()
			if mission_num > self.root_node.dependency_container.campaign.get_campaign_progress():
				self.root_node.dependency_container.campaign.update_campaign_progress(mission_num)
				self.root_node.dependency_container.controllers.campaign_menu_controller.fill_mission_data(mission_num + 1)
				self.root_node.dependency_container.controllers.menu_controller.update_campaign_progress_label()
	self.root_node.dependency_container.match_state.reset()

func play_destroy(field):
	sound_controller.play_unit_sound(field.object, sound_controller.SOUND_DIE)

func update_unit(field):
	hud_controller.update_unit_card(active_field.object)
	self.add_movement_indicators(active_field)

func move_unit(active_field, field):
	if self.root_node.dependency_container.movement_controller.move_object(active_field, field, self.actual_movement_tiles):
		sound_controller.play_unit_sound(field.object, sound_controller.SOUND_MOVE)
		self.use_ap(field)
		self.activate_field(field)
		self.root_node.dependency_container.abstract_map.map.fog_controller.clear_fog()
		#gather stats
		battle_stats.add_moves(self.current_player)

	else:
		sound_controller.play('no_moves')

func stats_start_time():
	battle_stats.start_counting_time()

func stats_set_time():
	battle_stats.set_counting_time(self.current_player)

func handle_battle(active_field, field):
	if (self.root_node.dependency_container.battle_controller.can_attack(active_field.object, field.object)):
		self.use_ap(field)
		self.root_node.dependency_container.abstract_map.reset()

		#print('MARK TRAIL!!')
		#TODO rewrite it to use pathfinding
		self.root_node.dependency_container.abstract_map.add_trails([active_field.object.move_positions], active_field.object.player, 2)

		sound_controller.play_unit_sound(field.object, sound_controller.SOUND_ATTACK)
		if (self.root_node.dependency_container.battle_controller.resolve_fight(active_field.object, field.object)):
		# sound_controller.play_unit_sound(active_field.object, sound_controller.SOUND_ATTACK)
		# if (battle_controller.resolve_fight(active_field.object, field.object)):
			self.play_destroy(field)
			self.destroy_unit(field)
			self.update_unit(active_field)

			#gather stats
			battle_stats.add_kills(current_player)
			self.collateral_damage(field.position)
		else:
			sound_controller.play_unit_sound(field.object, sound_controller.SOUND_DAMAGE)
			field.object.show_explosion()
			self.update_unit(active_field)
			# defender can deal damage
			if self.root_node.dependency_container.battle_controller.can_defend(field.object, active_field.object):
				if (self.root_node.dependency_container.battle_controller.resolve_defend(active_field.object, field.object)):
					self.play_destroy(active_field)
					self.destroy_unit(active_field)
					self.clear_active_field()

					#gather stats
					battle_stats.add_kills(abs(current_player - 1))
					self.collateral_damage(active_field.position)
				else:
					sound_controller.play_unit_sound(field.object, sound_controller.SOUND_DAMAGE)
					self.update_unit(active_field)
					active_field.object.show_explosion()
		self.root_node.dependency_container.abstract_map.map.fog_controller.clear_fog()
	else:
		sound_controller.play('no_attack')
		self.update_unit(active_field)

	return BREAK_EVENT_LOOP

func collateral_damage(center):
	var damage_chance = 0.5
	if randf() <= damage_chance:
		self.damage_terrain(center + Vector2(0, 1))
	if randf() <= damage_chance:
		self.damage_terrain(center + Vector2(1, 0))
	if randf() <= damage_chance:
		self.damage_terrain(center - Vector2(0, 1))
	if randf() <= damage_chance:
		self.damage_terrain(center - Vector2(1, 0))

	var field = self.root_node.dependency_container.abstract_map.get_field(center)
	if field.damage == null:
		field.add_damage(damage_layer)

func damage_terrain(position):
	var field = self.root_node.dependency_container.abstract_map.get_field(position)
	if field == null || field.object == null || field.object.group != 'terrain':
		return

	field.object.set_damage()
