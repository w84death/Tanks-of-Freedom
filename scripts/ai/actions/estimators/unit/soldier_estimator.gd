extends "res://scripts/ai/actions/estimators/unit/estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

const CAPTURE_MOD = 600
const ATTACK_MOD  = 450
const MOVE_MOD    = 200

# soldier / tank / heli
var danger_modifier = IntArray([0, 5, 1])

func _init(bag):
    self.bag = bag

func score_capture(action):

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

    var score = self.get_building_value(action) * self.BUILDING_WEIGHT
    # lower health is better
    score = score + (1 - self.__health_level(action.unit))
    if self.bag.controllers.action_controller.turn < 8:
        score = score * 1.2

    return self.CAPTURE_MOD + score


