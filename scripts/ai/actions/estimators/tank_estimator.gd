extends "res://scripts/ai/actions/estimators/unit_estimator.gd"

const BASE_MOVE = 1
const BASE_CAPTURE = 1
const BASE_ATTACK = 1

const CAPTURE_MOD = 200
const ATTACK_MOD  = 300
const MOVE_MOD    = 100

func _init(bag):
    self.bag = bag

func __score_capture(action):
    return 0