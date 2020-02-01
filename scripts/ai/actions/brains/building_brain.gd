extends "res://scripts/ai/actions/brains/base_brain.gd"


var close_threshold = 4

var base_spawn_score = 100
var in_danger_score = 100

var unit_amount_penalty = 50

var global_spawn_limit = 20


func _initialize():
    self.actions_templates['spawn'] = preload("res://scripts/ai/actions/types/spawn_unit_action.gd")


func get_actions(entity, enemies = {}, units = {}):
    var spawn_field = self.bag.abstract_map.get_field(entity.spawn_point)
    if spawn_field.object != null:
        return []

    var available_action_points = self.bag.controllers.action_controller.player_ap[entity.player]
    if entity.get_required_ap() > available_action_points:
        return []

    var spawn_limit = min(self.bag.ai.pathfinder.passable_field_count / 7, self.global_spawn_limit)
    if units.size() >= spawn_limit:
        return []


    var spawn_action = self.actions_templates["spawn"].new(entity)
    var score = self.base_spawn_score
    var distance

    for positionVAR in enemies:
        if enemies[positionVAR].type_name != "soldier":
            continue

        distance = self.bag.ai.pathfinder.get_distance(entity.position_on_map, positionVAR)
        if distance <= self.close_threshold:
            score = score + self.in_danger_score
            break

    if self._apply_amount_penalty(units):
        score = score - self.unit_amount_penalty

    spawn_action.set_score(score)

    return [spawn_action]


func _apply_amount_penalty(units):
    return false

func _count_units(units):
    var counts = {
        "soldier" : 0,
        "tank" : 0,
        "heli" : 0
    }

    for key in units:
        counts[units[key].type_name] += 1

    return counts
