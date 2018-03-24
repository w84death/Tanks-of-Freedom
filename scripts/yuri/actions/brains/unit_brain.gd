extends "res://scripts/yuri/actions/brains/base_brain.gd"

var preserve_ap = 1
var distance_penalty = 5

var base_attack_value = 80
var attack_bonus = 10
var kill_bonus = 40
var teamwork_bonus = 20
var building_protection_bonus = 50
var hq_protection_bonus = 50

var base_capture_value = 100
var immediate_capture_bonus = 50
var hq_capture_bonus = 500



func _initialize():
    self.actions_templates['attack'] = preload("res://scripts/yuri/actions/types/attack_action.gd")
    self.actions_templates['capture'] = preload("res://scripts/yuri/actions/types/capture_action.gd")

func get_actions(entity, enemies = {}, buildings = {}, allies = {}, own_buildings = {}):
    var attack_actions = []
    var capture_actions = []
    var other_actions = []
    var combined_actions = []

    if entity.ap == 0:
        return []

    attack_actions = self._get_attack_actions(entity, enemies, buildings, allies, own_buildings)

    if entity.can_capture_buildings():
        capture_actions = self._get_capture_actions(entity, enemies, buildings, allies, own_buildings)

    other_actions = self._get_other_actions(entity, enemies, buildings, allies, own_buildings)


    for action in attack_actions:
        combined_actions.append(action)
    for action in capture_actions:
        combined_actions.append(action)
    for action in other_actions:
        combined_actions.append(action)

    return combined_actions


func _get_attack_actions(entity, enemies, buildings, allies, own_buildings):
    var attack_actions = []
    var enemy
    var distance
    var base_obstacles = {}
    var obstacles = {}
    var path
    var action
    var score

    var has_backup = 0
    var protects_building = false
    var protects_hq = false

    if not entity.can_attack() or entity.ap <= self.preserve_ap:
        return []


    for building_position in buildings:
        base_obstacles[building_position] = building_position
    for building_position in own_buildings:
        base_obstacles[building_position] = building_position
        distance = self.bag.yuri_ai.pathfinding.get_distance(entity.position_on_map, building_position)
        if distance <= 4:
            protects_building = true
            if own_buildings[building_position].get_building_name() == "HQ":
                protects_hq = true
    for ally_position in allies:
        if ally_position != entity.position_on_map:
            base_obstacles[ally_position] = ally_position
        distance = self.bag.yuri_ai.pathfinding.get_distance(entity.position_on_map, ally_position)
        if distance <= 2:
            has_backup += 1
    for enemy_position in enemies:
        base_obstacles[enemy_position] = enemy_position

    for enemy_position in enemies:
        enemy = enemies[enemy_position]

        if not entity.can_attack_unit_type(enemy):
            continue

        distance = self.bag.yuri_ai.pathfinding.get_distance(entity.position_on_map, enemy.position_on_map)

        if distance > entity.max_ap + 4:
            continue

        if entity.ap == 1 and distance > 1:
            continue

        obstacles = base_obstacles.duplicate()
        obstacles.erase(enemy.position_on_map)
        self.bag.yuri_ai.pathfinding.set_obstacles(obstacles.keys())

        path = self.bag.yuri_ai.pathfinding.path_search(entity.position_on_map, enemy.position_on_map)

        if path.value > entity.max_ap + 4:
            continue

        if entity.ap == 1 and path.value > 2:
            continue

        score = self.base_attack_value

        if entity.ap >= path.value - 1:
            score += self.attack_bonus
            if entity.attack >= enemy.life:
                score += self.kill_bonus

        score += has_backup * self.teamwork_bonus

        if protects_building:
            score += self.building_protection_bonus
            if protects_hq:
                score += self.hq_protection_bonus

        if path.value > 2:
            score -= path.value * self.distance_penalty

        action = self.actions_templates["attack"].new(entity, path, enemy)
        action.set_score(score)

        attack_actions.append(action)

    return attack_actions


func _get_capture_actions(entity, enemies, buildings, allies, own_buildings):
    var capture_actions = []
    var target
    var path
    var base_obstacles = {}
    var obstacles = {}
    var score
    var action

    for building_position in buildings:
        base_obstacles[building_position] = building_position
    for building_position in own_buildings:
        base_obstacles[building_position] = building_position
    for ally_position in allies:
        if ally_position != entity.position_on_map:
            base_obstacles[ally_position] = ally_position
    for enemy_position in enemies:
        base_obstacles[enemy_position] = enemy_position

    if entity.ap == 0:
        return []

    for building_position in buildings:
        target = buildings[building_position]

        obstacles = base_obstacles.duplicate()
        obstacles.erase(target.position_on_map)
        self.bag.yuri_ai.pathfinding.set_obstacles(obstacles.keys())

        path = self.bag.yuri_ai.pathfinding.path_search(entity.position_on_map, target.position_on_map)

        score = self.base_capture_value

        if entity.ap >= path.value - 1:
            score += self.immediate_capture_bonus
            if target.get_building_name() == "HQ":
                score += self.hq_capture_bonus

        if path.value > 2:
            score -= path.value * self.distance_penalty

        action = self.actions_templates["capture"].new(entity, path, target)
        action.set_score(score)

        capture_actions.append(action)

    return capture_actions


func _get_other_actions(entity, enemies, buildings, allies, own_buildings):
    return []

