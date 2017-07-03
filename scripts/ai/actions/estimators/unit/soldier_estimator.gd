extends "res://scripts/ai/actions/estimators/unit/estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

const CAPTURE_MOD = 400
const ATTACK_MOD  = 300
const MOVE_MOD    = 100

# soldier / tank / heli
var capture_modifiers = IntArray([5, 2, 2])
var attack_modifiers = IntArray([4, 6, 7])
var move_capture_modifiers = IntArray([5, 1, 3])
var move_attack_modifiers = IntArray([2, 2, 3])
var danger_modifier = IntArray([1, 5, 2])

func _init(bag):
    self.bag = bag

func __score_capture(action):
    if action.unit.life == 0 or !self.has_ap(action):
        return 0

    var enemy = self.get_target_object(action)
    if action.unit.player == enemy.player:
        return 0

    if !self.target_can_be_captured(action):
        return 0

    if.get_target_object(action).type == 0:
        return 99999

    if self.get_target_object(action).type == 4 and self.enemies_in_sight(action).size() > 2:
        return 0

    var score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # lower health is better
    score = score + (1 - self.__health_level(action.unit))

    return self.CAPTURE_MOD + score


