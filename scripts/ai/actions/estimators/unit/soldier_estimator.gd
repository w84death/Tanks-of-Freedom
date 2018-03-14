extends "res://scripts/ai/actions/estimators/unit/estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

const CAPTURE_MOD = 600
const ATTACK_MOD  = 450

# soldier / tank / heli
var danger_modifier = IntArray([0, 5, 1])

func _init(bag):
    self.bag = bag




