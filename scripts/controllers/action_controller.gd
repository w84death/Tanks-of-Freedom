
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
var turn = 1
var title
var camera
var is_cpu_player

var game_ended = false

var interaction_indicators = {
    'bl' : { 'offset' : Vector2(0, 1), 'indicator' : null },
    'br' : { 'offset' : Vector2(1, 0), 'indicator' : null },
    'tl' : { 'offset' : Vector2(-1, 0), 'indicator' : null },
    'tr' : { 'offset' : Vector2(0, -1), 'indicator' : null }
}

const BREAK_EVENT_LOOP = 1
const AP_HANDICAP = 0.8

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
    self.is_cpu_player = false
    self.player_ap = [0, 0]
    self.turn = 1
    self.title = null
    self.camera = null
    self.game_ended = false

func init_root(root, map, hud):
    self.reset()
    self.root_node = root
    self.root_tree = self.root_node.get_tree()

    self.root_node.bag.abstract_map.reset()
    self.root_node.bag.abstract_map.init_map(map)
    self.root_node.bag.action_map.init_map(map)

    camera = root.scale_root
    ysort = map.get_node('terrain/front')
    damage_layer = map.get_node('terrain/destruction')
    selector = root.selector
    self.import_objects()
    hud_controller.init_root(root, self, hud)
    hud_controller.set_turn(turn)
    if not root_node.settings['cpu_0']:
        hud_controller.show_in_game_card([], self.current_player)

    self.positions = self.root_node.bag.positions
    self.positions.get_player_bunker_position(self.current_player)
    self.positions.bootstrap()

    self.battle_stats = preload("res://scripts/battle_stats.gd").new()

    sound_controller = root.sound_controller

    self.root_node.bag.abstract_map.create_tile_type_map()
    self.root_node.bag.abstract_map.update_terrain_tile_type_map(self.positions.get_terrain_obstacles())

    pathfinding = preload('res://scripts/ai/pathfinding/a_star_pathfinding.gd').new()
    ai = preload("res://scripts/ai/ai.gd").new(self.positions, pathfinding, self.root_node.bag.abstract_map, self)

    var interaction_template = preload('res://gui/movement.xscn')
    for direction in self.interaction_indicators:
        self.interaction_indicators[direction]['indicator'] = interaction_template.instance()
        ysort.add_child(self.interaction_indicators[direction]['indicator'])
        self.interaction_indicators[direction]['indicator'].hide()

    demo_timer = root_node.get_node("DemoTimer")

func set_active_field(position):
    var field = self.root_node.bag.abstract_map.get_field(position)
    self.clear_active_field()
    self.activate_field(field)

    self.move_camera_to_point(field.position)

    return field

func handle_action(position):
    if game_ended:
        return 0

    #if active_field == null:
    #   return 1

    var field = self.root_node.bag.abstract_map.get_field(position)
    if field.object != null:
        if active_field != null:
            if field.object.group == 'unit' && active_field.object.group == 'unit':

                if active_field.is_adjacent(field) && field.object.player != self.current_player && self.has_ap():
                    if (self.handle_battle(active_field, field) == BREAK_EVENT_LOOP):
                        return 0
                else:
                    sound_controller.play('no_move')

                    hud_controller.update_unit_card(active_field.object)
            if active_field.object.group == 'unit' && active_field.object.type == 0 && field.object.group == 'building' && field.object.player != self.current_player:
                if active_field.is_adjacent(field) && self.root_node.bag.movement_controller.can_move(active_field, field) && self.has_ap():
                    if (self.capture_building(active_field, field) == BREAK_EVENT_LOOP):
                        return 0

        if (field.object.group == 'unit' || (field.object.group == 'building' && field.object.can_spawn)) && field.object.player == self.current_player:
            self.activate_field(field)
    else:
        if active_field != null && active_field.object != null && field != active_field && field.object == null:
            if active_field.object.group == 'unit'  && self.is_movement_possible(field, active_field) && field.terrain_type != -1 && self.has_ap():
                self.move_unit(active_field, field)
            else:
                self.clear_active_field()

    return 1

func capture_building(active_field, field):
    self.use_ap(field)

    field.object.claim(self.current_player, self.turn)
    sound_controller.play('occupy_building')
    self.root_node.bag.ap_gain.update()
    if field.object.type == 4:
        active_field.object.takeAllAP()
    else:
        self.despawn_unit(active_field)
    self.root_node.bag.fog_controller.clear_fog()
    self.activate_field(field)
    if field.object.type == 0:
        self.end_game(self.current_player)
        return 1

func activate_field(field):
    self.clear_active_field()
    self.active_field = field
    self.root_node.bag.abstract_map.tilemap.add_child(active_indicator)
    self.root_node.bag.abstract_map.tilemap.move_child(active_indicator, 0)
    var position = Vector2(self.root_node.bag.abstract_map.tilemap.map_to_world(field.position))
    position.y += 2
    active_indicator.set_pos(position)
    sound_controller.play('select')
    if not self.is_cpu_player:
        if field.object.group == 'unit':
            self.hud_controller.show_unit_card(field.object, self.current_player)
            self.add_movement_indicators(field)
        if field.object.group == 'building' && not self.is_cpu_player:
            self.hud_controller.show_building_card(field.object, player_ap[self.current_player])

func clear_active_field():
    self.active_field = null
    self.root_node.bag.abstract_map.tilemap.remove_child(active_indicator)
    if not self.is_cpu_player:
        self.hud_controller.clear_unit_card()
        self.hud_controller.clear_building_card()
        self.root_node.bag.action_map.reset()
        self.hide_interaction_indicators()

func add_movement_indicators(field):
    self.root_node.bag.action_map.reset()
    if player_ap[self.current_player] > 0 && field.object.ap > 0 && not self.is_cpu_player:
        # calculating range
        var tiles_range = min(field.object.ap, player_ap[self.current_player])
        var first_action_range = max(0, ceil(field.object.ap - 1))

        var unit_position = field.object.get_pos_map()

        self.actual_movement_tiles.clear()

        var tiles = self.root_node.bag.action_map.find_movement_tiles(field, tiles_range)

        for tile in tiles:
            self.actual_movement_tiles[tile] = tiles[tile]

        self.root_node.bag.action_map.mark_movement_tiles(field, tiles, first_action_range, self.current_player)
    self.add_interaction_indicators(field)

func add_interaction_indicators(field):
    var neighbour
    var indicator
    var indicator_position

    if player_ap[self.current_player] == 0:
        return

    for direction in self.interaction_indicators:
        indicator = self.interaction_indicators[direction]['indicator']
        indicator.hide()

        neighbour = self.root_node.bag.abstract_map.get_field(Vector2(field.position) + self.interaction_indicators[direction]['offset'])

        if neighbour.terrain_type == -1:
            continue

        indicator_position = Vector2(self.root_node.bag.abstract_map.tilemap.map_to_world(neighbour.position))

        if neighbour.has_attackable_enemy(field.object):
            indicator.set_pos(indicator_position + Vector2(1, 1))
            indicator.show()
            indicator.get_node('anim').play("attack")
        if neighbour.has_capturable_building(field.object) && self.root_node.bag.movement_controller.can_move(field, neighbour):
            indicator.set_pos(indicator_position)
            indicator.show()
            indicator.get_node('anim').play("enter")

func hide_interaction_indicators():
    for direction in self.interaction_indicators:
        self.interaction_indicators[direction]['indicator'].hide()

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
    var spawn_point = self.root_node.bag.abstract_map.get_field(active_object.spawn_point)
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
        self.battle_stats.add_spawn(self.current_player)
        self.root_node.bag.fog_controller.clear_fog()

func import_objects():
    self.attach_objects(self.root_tree.get_nodes_in_group("units"))
    self.attach_objects(self.root_tree.get_nodes_in_group("buildings"))
    self.attach_objects(self.root_tree.get_nodes_in_group("terrain"))

func attach_objects(collection):
    for entity in collection:
        self.root_node.bag.abstract_map.get_field(entity.get_initial_pos()).object = entity

func end_turn():
    self.stats_set_time()
    if self.root_node.settings['turns_cap'] > 0:
        if self.turn >= self.root_node.settings['turns_cap']:
            self.end_game(-1)
            return

    sound_controller.play('end_turn')
    if self.current_player == 0:
        self.switch_to_player(1)
    else:
        self.turn += 1
        self.switch_to_player(0)
    hud_controller.set_turn(turn)

    #gather stats
    self.battle_stats.add_domination(self.current_player, self.positions.get_player_buildings(self.current_player).size())

func move_camera_to_active_bunker():
    var bunker_position = self.positions.get_player_bunker_position(current_player)
    if bunker_position != null:
        self.move_camera_to_point(bunker_position)
        self.root_node.move_selector_to_map_position(bunker_position)

func move_camera_to_point(position):
    self.root_node.bag.abstract_map.map.move_to_map(position)

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
    if self.is_cpu_player:
        return active_field.is_adjacent(field)

    var position = field.position
    if self.actual_movement_tiles.has(position):
        return true

    return false

func deduct_ap(ap):
    var units
    self.update_ap(player_ap[current_player] - ap)
    if self.player_ap[self.current_player] < 1:
        units = self.positions.get_player_units(current_player)
        for unit in units:
            units[unit].force_no_ap_idle()

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
    var bonus_ap = 0
    for building in buildings:
        bonus_ap = bonus_ap + buildings[building].bonus_ap
    if self.apply_handicap():
        bonus_ap = floor(bonus_ap * self.AP_HANDICAP)
    self.update_ap(total_ap + bonus_ap)

func show_bonus_ap():
    var buildings = self.positions.get_player_buildings(current_player)
    for building_pos in buildings:
        if buildings[building_pos].bonus_ap > 0 && not self.root_node.bag.fog_controller.is_fogged(building_pos):
            buildings[building_pos].show_floating_ap()

func switch_to_player(player, save_game=true):
    self.stats_start_time()
    self.clear_active_field()
    current_player = player
    self.is_cpu_player = root_node.settings['cpu_' + str(current_player)]

    self.reset_player_units(player)
    selector.set_player(player);
    self.root_node.bag.abstract_map.map.current_player = player
    if root_node.settings['cpu_' + str(player)]:
        self.refill_ap()
        root_node.start_ai_timer()
        root_node.lock_for_cpu()
        self.move_camera_to_active_bunker()
        self.show_bonus_ap()
        self.ai.set_ap_for_turn(self.player_ap[player])
    else:
        root_node.unlock_for_player()
        hud_controller.show_in_game_card([], current_player)
        self.root_node.bag.controllers.hud_panel_controller.info_panel.end_button_enable()
        if save_game:
            self.root_node.bag.saving.save_state()
        self.refill_ap()
    self.root_node.bag.fog_controller.clear_fog()
    self.root_node.bag.ap_gain.update()

    # probably not needed
    self.root_node.bag.unit_switcher.reset()

func perform_ai_stuff():
    var success = false
    if self.is_cpu_player && player_ap[current_player] > 0:
        success = ai.gather_available_actions(player_ap[current_player])

    self.hud_controller.update_cpu_progress(player_ap[current_player], ai.ap_for_turn)

    return player_ap[current_player] > 0 && success

func apply_handicap():
    if self.root_node.settings['easy_mode']:
        if self.is_cpu_player && !(root_node.settings['cpu_1'] && root_node.settings['cpu_0']):
            return true

    return false

func reset_player_units(player):
    var units = self.positions.get_player_units(player)
    var limit_ap = self.apply_handicap()
    for unit_pos in units:
        units[unit_pos].reset_ap(limit_ap)

func end_game(winning_player):
    self.root_node.ai_timer.reset_state()
    self.clear_active_field()
    game_ended = true
    if root_node.hud.is_hidden():
        root_node.hud.show()
    hud_controller.show_win(winning_player, self.battle_stats.get_stats(), turn)
    selector.hide()
    if (root_node.is_demo):
        demo_timer.reset(demo_timer.STATS)
        demo_timer.start()
    if (self.root_node.bag.match_state.is_campaign()) && winning_player > -1:
        if not self.root_node.settings['cpu_' + str(winning_player)]:
            var mission_num = self.root_node.bag.match_state.get_map_number()
            if mission_num > self.root_node.bag.campaign.get_campaign_progress():
                self.root_node.bag.campaign.update_campaign_progress(mission_num)
                self.root_node.bag.controllers.campaign_menu_controller.fill_mission_data(mission_num + 1)
                self.root_node.bag.controllers.menu_controller.update_campaign_progress_label()
    self.root_node.bag.match_state.reset()
    if not self.root_node.is_demo_mode():
        self.root_node.bag.saving.invalidate_save_file()
    self.root_node.bag.timers.set_timeout(0.1, hud_controller.hud_end_game_missions_button, "grab_focus")

func play_destroy(field):
    sound_controller.play_unit_sound(field.object, sound_controller.SOUND_DIE)

func update_unit(field):
    if !self.is_cpu_player:
        hud_controller.update_unit_card(active_field.object)
        self.add_movement_indicators(active_field)

func move_unit(active_field, field):
    var action_cost = self.root_node.bag.movement_controller.TERRAIN_COST
    if !self.is_cpu_player && self.actual_movement_tiles.has(field.position):
        action_cost = self.actual_movement_tiles[field.position]

    if self.root_node.bag.movement_controller.move_object(active_field, field, action_cost):
        sound_controller.play_unit_sound(field.object, sound_controller.SOUND_MOVE)
        self.use_ap(field)
        self.activate_field(field)
        self.root_node.bag.fog_controller.clear_fog()
        #gather stats
        self.battle_stats.add_moves(self.current_player)
        self.update_unit(self.active_field)

    else:
        sound_controller.play('no_moves')

func stats_start_time():
    self.battle_stats.start_counting_time()

func stats_set_time():
    self.battle_stats.set_counting_time(self.current_player)

func handle_battle(active_field, field):
    if (self.root_node.bag.battle_controller.can_attack(active_field.object, field.object)):
        self.use_ap(field)

        sound_controller.play_unit_sound(field.object, sound_controller.SOUND_ATTACK)
        if (self.root_node.bag.battle_controller.resolve_fight(active_field.object, field.object)):
            self.play_destroy(field)
            self.destroy_unit(field)
            self.update_unit(active_field)

            #gather stats
            self.battle_stats.add_kills(current_player)
            self.collateral_damage(field.position)
        else:
            sound_controller.play_unit_sound(field.object, sound_controller.SOUND_DAMAGE)
            field.object.show_explosion()
            self.update_unit(active_field)
            # defender can deal damage
            if self.root_node.bag.battle_controller.can_defend(field.object, active_field.object):
                if (self.root_node.bag.battle_controller.resolve_defend(active_field.object, field.object)):
                    self.play_destroy(active_field)
                    self.destroy_unit(active_field)
                    self.clear_active_field()

                    #gather stats
                    self.battle_stats.add_kills(abs(current_player - 1))
                    self.collateral_damage(active_field.position)
                else:
                    sound_controller.play_unit_sound(field.object, sound_controller.SOUND_DAMAGE)
                    self.update_unit(active_field)
                    active_field.object.show_explosion()
        self.root_node.bag.fog_controller.clear_fog()
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

    var field = self.root_node.bag.abstract_map.get_field(center)
    if field.damage == null:
        field.add_damage(damage_layer)

func damage_terrain(position):
    var field = self.root_node.bag.abstract_map.get_field(position)
    if field == null || field.object == null || field.object.group != 'terrain':
        return

    field.object.set_damage()

func refresh_hud():
    hud_controller.set_turn(self.turn)
    hud_controller.update_ap(player_ap[current_player])

func switch_to_next_unit():
    if not self.is_cpu_player:
        var unit = self.root_node.bag.unit_switcher.next_unit(self.current_player, self.active_field)
        if unit != null :
            var unit_field = self.root_node.bag.abstract_map.get_field(unit.get_pos_map())
            self.activate_field(unit_field)
