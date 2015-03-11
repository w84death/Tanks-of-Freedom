
var root_node
var abstract_map = preload('abstract_map.gd').new()
var ysort
var selector
var active_field = null
var active_indicator = preload('res://gui/selector.xscn').instance()
var battle_controller = preload('battle_controller.gd').new()
var movement_controller = preload('movement_controller.gd').new()
var hud_controller = preload('hud_controller.gd').new()
var position_controller = preload("position_controller.gd").new()
var sound_controller
var ai
var pathfinding

var current_player = 0
var player_ap = [0,0]
var player_ap_max = 1
var turn = 1
var title
var camera
var camera_zoom_range = [1,6]

var game_ended = false

var movement_arrow_bl
var movement_arrow_br
var movement_arrow_tl
var movement_arrow_tr

const BREAK_EVENT_LOOP = 1

func set_active_field(position):
	var field = abstract_map.get_field(position)
	self.clear_active_field()
	self.activate_field(field)

	self.move_camera_to_point(field.position)

	return field

func handle_action(position):
	if game_ended:
		return

	var field = abstract_map.get_field(position)

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
				if active_field.is_adjacent(field) && movement_controller.can_move(active_field, field) && self.has_ap():
					if (self.capture_building(active_field, field) == BREAK_EVENT_LOOP):
						return
		if (field.object.group == 'unit' || (field.object.group == 'building' && field.object.can_spawn)) && field.object.player == current_player:
			self.activate_field(field)
	else:
		if active_field != null && active_field.object != null && field != active_field && field.object == null:
			if active_field.object.group == 'unit' && active_field.is_adjacent(field) && field.terrain_type != -1 && self.has_ap():
				self.move_unit(active_field, field)

func post_handle_action():
	position_controller.refresh_units()

func capture_building(active_field, field):
	self.use_ap()
	field.object.claim(current_player)
	sound_controller.play('pickup_box')
	self.despawn_unit(active_field)

	self.activate_field(field)
	if field.object.type == 0:
		root_node.ai_timer.reset_state()
		self.end_game()
		return 1


func init_root(root, map, hud):
	root_node = root
	abstract_map.tilemap = map.get_node("terrain")
	camera = root.scale_root
	ysort = map.get_node('terrain/YSort')
	selector = root.selector
	self.import_objects()
	hud_controller.init_root(root, self, hud)
	hud_controller.set_turn(turn)
	if not root_node.settings['cpu_0']:
		hud_controller.show_in_game_card(["Welcome!","You are the blue player.","The red one is the bad guy."],current_player)
	position_controller.init_root(root)
	position_controller.get_player_bunker_position(current_player)
	sound_controller = root.sound_controller

	pathfinding = preload('ai/a_star_pathfinding.gd').new()
	ai = preload("ai/ai.gd").new(position_controller, pathfinding, abstract_map, self)

	var movement_template = preload('res://gui/movement.xscn')
	movement_arrow_bl = movement_template.instance()
	movement_arrow_br = movement_template.instance()
	movement_arrow_tl = movement_template.instance()
	movement_arrow_tr = movement_template.instance()

func activate_field(field):
	self.clear_active_field()
	if !field.object: #todo - investigate why there is no object
		print("FAIL to activate field: ", field.position)
	active_field = field
	abstract_map.tilemap.add_child(active_indicator)
	abstract_map.tilemap.move_child(active_indicator,0)
	var position = Vector2(abstract_map.tilemap.map_to_world(field.position))
	position.y += 2
	active_indicator.set_pos(position)
	sound_controller.play('select')
	if field.object.group == 'unit':
		hud_controller.show_unit_card(field.object, current_player)
		self.add_movement_indicators(field)
	if field.object.group == 'building' && not root_node.settings['cpu_' + str(current_player)]:
		hud_controller.show_building_card(field.object)

func clear_active_field():
	active_field = null
	abstract_map.tilemap.remove_child(active_indicator)
	hud_controller.clear_unit_card()
	hud_controller.clear_building_card()
	self.clear_movement_indicators()

func add_movement_indicators(field):
	var top_left = abstract_map.get_field(Vector2(field.position) + Vector2(-1, 0))
	var top_right = abstract_map.get_field(Vector2(field.position) + Vector2(0, -1))
	var bottom_left = abstract_map.get_field(Vector2(field.position) + Vector2(0, 1))
	var bottom_right = abstract_map.get_field(Vector2(field.position) + Vector2(1, 0))
	self.mark_field(field, top_left, movement_arrow_tl, 'tl')
	self.mark_field(field, top_right, movement_arrow_tr, 'tr')
	self.mark_field(field, bottom_left, movement_arrow_bl, 'bl')
	self.mark_field(field, bottom_right, movement_arrow_br, 'br')

func mark_field(source, target, indicator, direction):
	if target.terrain_type == -1:
		return

	if player_ap[current_player] > 0:
		var position = Vector2(abstract_map.tilemap.map_to_world(target.position))
		if target.object == null:
			if movement_controller.can_move(source, target):
				indicator.set_pos(position)
				ysort.add_child(indicator)
				indicator.get_node('anim').play("move_" + direction)
		else:
			#print(target.object)
			if target.object.group == 'unit':
				if target.object.player != current_player && battle_controller.can_attack(source.object, target.object):
					indicator.set_pos(position)
					ysort.add_child(indicator)
					indicator.get_node('anim').play("attack")
			if target.object.group == 'building' && target.object.player != current_player && source.object.type == 0:
				if movement_controller.can_move(source, target):
					indicator.set_pos(position)
					ysort.add_child(indicator)
					indicator.get_node('anim').play("enter")
	else:
		ysort.remove_child(indicator)

func clear_movement_indicators():
	ysort.remove_child(movement_arrow_bl)
	ysort.remove_child(movement_arrow_br)
	ysort.remove_child(movement_arrow_tl)
	ysort.remove_child(movement_arrow_tr)
	return

func despawn_unit(field):
	ysort.remove_child(field.object)
	field.object.queue_free()
	field.object = null

func destroy_unit(field):
	field.object.die_after_explosion(ysort)
	field.object = null

func spawn_unit_from_active_building():
	if active_field == null || active_field.object.group != 'building' || active_field.object.can_spawn == false:
		return
	var spawn_point = abstract_map.get_field(active_field.object.spawn_point)
	var required_ap = active_field.object.get_required_ap()
	if spawn_point.object == null && self.has_enough_ap(required_ap):
		var unit = active_field.object.spawn_unit(current_player)
		ysort.add_child(unit)
		unit.set_pos_map(spawn_point.position)
		spawn_point.object = unit
		self.deduct_ap(required_ap)
		sound_controller.play('spawn')
		self.activate_field(spawn_point)
		self.move_camera_to_point(spawn_point.position)

func toggle_unit_details_view():
	hud_controller.toggle_unit_details_view(current_player)

func import_objects():
	self.attach_objects(root_node.get_tree().get_nodes_in_group("units"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("buildings"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("terrain"))

func attach_objects(collection):
	for entity in collection:
		abstract_map.get_field(entity.get_initial_pos()).object = entity

func end_turn():
	sound_controller.play('end_turn')
	if current_player == 0:
		self.switch_to_player(1)
	else:
		self.switch_to_player(0)
		turn += 1
	hud_controller.set_turn(turn)

func move_camera_to_active_bunker():
	self.move_camera_to_point(position_controller.get_player_bunker_position(current_player))

func move_camera_to_point(position):
	abstract_map.tilemap.move_to_map(position)

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

func use_ap():
	self.deduct_ap(1)

func deduct_ap(ap):
	self.update_ap(player_ap[current_player] - ap)

func update_ap(ap):
	player_ap[current_player] = ap
	hud_controller.update_ap(player_ap[current_player])
	if player_ap[current_player] == 0:
		hud_controller.warn_end_turn()

func refill_ap():
	position_controller.refresh_units()
	position_controller.refresh_buildings()

	var total_ap = player_ap[current_player]
	var buildings = position_controller.get_player_buildings(current_player)
	for building in buildings:
		total_ap = total_ap + buildings[building].bonus_ap
	self.update_ap(total_ap)

func show_bonus_ap():
	var buildings = position_controller.get_player_buildings(current_player)
	for building in buildings:
		if buildings[building].bonus_ap > 0:
			buildings[building].show_floating_ap()

func switch_to_player(player):
	self.clear_active_field()
	current_player = player
	self.reset_player_units(player)
	selector.set_player(player);
	self.refill_ap()
	if root_node.settings['cpu_' + str(player)]:
		root_node.start_ai_timer()
		root_node.lock_for_cpu()
		self.move_camera_to_active_bunker()
		self.show_bonus_ap()
	else:
		root_node.unlock_for_player()
		hud_controller.show_in_game_card(["winning conditions:", "- Take the control of the enemy HQ!", "- destroy all enemy units"], current_player)


func perform_ai_stuff():
	var success = false
	if root_node.settings['cpu_' + str(current_player)] && player_ap[current_player] > 0:
		abstract_map.create_tile_type_maps()
		success = ai.gather_available_actions(player_ap[current_player])

	return player_ap[current_player] > 0 && success

func reset_player_units(player):
	var units = root_node.get_tree().get_nodes_in_group("units")
	for unit in units:
		if unit.player == player:
			unit.reset_ap()

func end_game():
	self.clear_active_field()
	game_ended = true
	hud_controller.show_win(current_player)
	selector.hide()

func camera_zoom_in():
	var scale = camera.get_scale()
	if scale.x < camera_zoom_range[1]:
		camera.set_scale(scale + Vector2(1,1))
	abstract_map.tilemap.scale = camera.get_scale()

func camera_zoom_out():
	var scale = camera.get_scale()
	if scale.x > camera_zoom_range[0]:
		camera.set_scale(scale - Vector2(1,1))
	abstract_map.tilemap.scale = camera.get_scale()

func play_destroy(field):
	if (field.object.type == 0):
		sound_controller.play('hurt')
	else:
		sound_controller.play('explosion')

func update_unit(field):
	hud_controller.update_unit_card(active_field.object)
	self.add_movement_indicators(active_field)

func move_unit(active_field, field):
	if movement_controller.move_object(active_field, field):
		sound_controller.play('move')
		self.use_ap()
		self.activate_field(field)
	else:
		sound_controller.play('no_moves')

func handle_battle(active_field, field):
	if (battle_controller.can_attack(active_field.object, field.object)):
		self.use_ap()
		self.clear_movement_indicators()

		if (battle_controller.resolve_fight(active_field.object, field.object)):
			#print('attacker kill defender');
			self.play_destroy(field)
			self.destroy_unit(field)
			self.update_unit(active_field)
		else:
			sound_controller.play('not_dead')
			field.object.show_explosion()
			self.update_unit(active_field)
			# defender can deal damage
			#print('defend!')
			if battle_controller.can_defend(field.object, active_field.object):
				if (battle_controller.resolve_defend(active_field.object, field.object)):
					#print('defender kill attacker');
					self.play_destroy(active_field)
					self.destroy_unit(active_field)
					self.clear_active_field()
				else:
					sound_controller.play('not_dead')
					self.update_unit(active_field)
					active_field.object.show_explosion()

	else:
		sound_controller.play('no_attack')

	return BREAK_EVENT_LOOP
