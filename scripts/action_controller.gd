
var root_node
var abstract_map = preload('abstract_map.gd').new()
var selector
var active_field = null
var active_indicator = preload('res://units/selector.xscn').instance()
var battle_controller = preload('battle_controller.gd').new()
var movement_controller = preload('movement_controller.gd').new()
var hud_controller = preload('hud_controller.gd').new()
var sample_player

var current_player = 1
var player_ap = 10
var player_ap_max = 10
var turn = 1

var game_ended = false

func handle_action(position):
	if game_ended:
		return
	
	var field = abstract_map.get_field(position)
	
	if field.object != null:
		if active_field != null:
			if field.object.group == 'unit' && active_field.object.group == 'unit':
				if active_field.is_adjacent(field) && field.object.player != current_player && self.has_ap():
					self.use_ap()
					if (battle_controller.can_attack(active_field.object, field.object)):
						if (battle_controller.resolve_fight(active_field.object, field.object)):
							if (field.object.type == 0):
								sample_player.play('hurt')
							else:
								sample_player.play('explosion')
							self.despawn_unit(field)
							hud_controller.update_unit_card(active_field.object)
							return
						else:
							sample_player.play('not_dead')
					else:
						sample_player.play('no_attack')
				else:
					sample_player.play('no_move')
					
					hud_controller.update_unit_card(active_field.object)
					
			if active_field.object.group == 'unit' && active_field.object.type == 0 && field.object.group == 'building' && field.object.player != current_player:
				if active_field.is_adjacent(field) && movement_controller.can_move(active_field, field) && self.has_ap():
					self.use_ap()
					field.object.claim(current_player)
					sample_player.play('pickup_box')
					self.despawn_unit(active_field)
					self.activate_field(field)
					if field.object.type == 0:
						self.end_game()
						return
		if (field.object.group == 'unit' || field.object.group == 'building') && field.object.player == current_player:
			self.activate_field(field)
	else:
		if active_field != null && active_field.object != null && field != active_field && field.object == null:
			if active_field.object.group == 'unit' && active_field.is_adjacent(field) && field.terrain_type != -1 && self.has_ap():
				if movement_controller.move_object(active_field, field):
					sample_player.play('move')
					self.activate_field(field)
					self.use_ap()
				else:
					sample_player.play('no_moves')

func init_root(root):
	root_node = root
	abstract_map.tilemap = root.get_node("/root/game/pixel_scale/map")
	selector = root.get_node('/root/game/pixel_scale/map/YSort/selector')
	sample_player = root.get_node("/root/game/SamplePlayer")
	active_indicator.set_region_rect(Rect2(64, 0, 32, 32))
	self.import_objects()
	hud_controller.init_root(root, self)
	hud_controller.set_turn(turn)

func activate_field(field):
	self.clear_active_field()
	active_field = field
	abstract_map.tilemap.add_child(active_indicator)
	var position = Vector2(abstract_map.tilemap.map_to_world(field.position))
	position.y += 2
	active_indicator.set_pos(position)
	sample_player.play('select')
	if field.object.group == 'unit':
		hud_controller.show_unit_card(field.object)
	if field.object.group == 'building':
		hud_controller.show_building_card(field.object)

func clear_active_field():
	active_field = null
	abstract_map.tilemap.remove_child(active_indicator)
	hud_controller.clear_unit_card()
	hud_controller.clear_building_card()

func despawn_unit(field):
	abstract_map.tilemap.remove_child(field.object)
	field.object.queue_free()
	field.object = null

func spawn_unit_from_active_building():
	if active_field == null || active_field.object.group != 'building':
		return
	var spawn_point = abstract_map.get_field(active_field.object.spawn_point)
	var required_ap = active_field.object.get_required_ap()
	if spawn_point.object == null && self.has_enough_ap(required_ap):
		var unit = active_field.object.spawn_unit(current_player)
		abstract_map.tilemap.add_child(unit)
		unit.set_pos_map(spawn_point.position)
		spawn_point.object = unit
		self.deduct_ap(required_ap)
		sample_player.play('spawn')

func import_objects():
	self.attach_objects(root_node.get_tree().get_nodes_in_group("units"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("buildings"))
	self.attach_objects(root_node.get_tree().get_nodes_in_group("terrain"))

func attach_objects(collection):
	for entity in collection:
		abstract_map.get_field(entity.get_initial_pos()).object = entity
		
func end_turn():
	sample_player.play('end_turn')
	if current_player == 0:
		self.switch_to_player(1)
	else:
		self.switch_to_player(0)
		turn += 1
	hud_controller.set_turn(turn)

func has_ap():
	if player_ap > 0:
		return true
	
	sample_player.play('no_moves')
	return false
	
func has_enough_ap(ap):
	if player_ap >= ap:
		return true
	return false

func use_ap():
	self.deduct_ap(1)
	
func deduct_ap(ap):
	self.update_ap(player_ap - ap)
	
func update_ap(ap):
	player_ap = ap
	hud_controller.update_ap(player_ap)

func switch_to_player(player):
	self.clear_active_field()
	current_player = player
	self.reset_player_units(player)
	selector.set_region_rect(Rect2(player * 32, 0, 32, 32))
	self.update_ap(player_ap_max)

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
