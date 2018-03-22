extends "res://scripts/yuri/actions/brains/base_brain.gd"

func get_actions(entity, enemies = {}, buildings = {}, allies = {}, own_buildings = {}):
    var attack_actions = []
    var capture_actions = []
    var other_actions = []
    var combined_actions = []

    if entity.ap == 0:
        return []

    self._set_obstacles_for_attacks(entity, buildings, allies, own_buildings)
    attack_actions = self._get_attack_actions(entity, enemies)

    if entity.can_capture_buildings():
        capture_actions = self._get_capture_actions(entity, buildings)

    self._set_obstacles_for_other_actions(entity, enemies, buildings, allies, own_buildings)
    other_actions = self._get_other_actions(entity, enemies, buildings, allies, own_buildings)


    for action in attack_actions:
        combined_actions.append(action)
    for action in capture_actions:
        combined_actions.append(action)
    for action in other_actions:
        combined_actions.append(action)

    return combined_actions


func _get_attack_actions(entity, enemies = {}):
    return []


func _get_capture_actions(entity, buildings = {}):
    return []


func _get_other_actions(entity, enemies, buildings, allies, own_buildings):
    return []


func _set_obstacles_for_capturing(entity, enemies, allies, own_buildings):
    return


func _set_obstacles_for_attacks(entity, buildings, allies, own_buildings):
    return


func _set_obstacles_for_other_actions(entity, enemies, buildings, allies, own_buildings):
    return


func _apply_obstacles_to_pathfinding(obstacles):
    return
