extends "res://scripts/bag_aware.gd"

const RANDOM_VALUE = 0.03

var estimators = []
var building_estimator

func _initialize():
    self.estimators = [
        load('res://scripts/ai/actions/estimators/unit/soldier_estimator.gd').new(self.bag),
        load('res://scripts/ai/actions/estimators/unit/tank_estimator.gd').new(self.bag),
        load('res://scripts/ai/actions/estimators/unit/helicopter_estimator.gd').new(self.bag)
    ]

    self.building_estimator = load('res://scripts/ai/actions/estimators/building/estimator.gd').new(self.bag)

func score(action):
    action.score = 0
    action.type = "null"

    if action.is_building_action():
        action.score = self.building_estimator.score(action)
        action.type = "spawn"
    else:
        var next_tile = self.__get_next_tile_from_path(action.path)
        if next_tile != null:
            if (next_tile.object == null):
                action.score = self.estimators[action.unit.type].score_move(action)
                action.type = "move"
            else:
                if next_tile.has_capturable_building(action.unit):
                    action.score = self.estimators[action.unit.type].score_capture(action)
                    action.type = "capture"
                elif next_tile.has_attackable_enemy(action.unit):
                    action.score = self.estimators[action.unit.type].score_attack(action)
                    action.type = "attack"


    self.__add_random(action)

func __add_random(action):
    if action.score > 0:
        randomize()
        action.score = action.score + (action.score * self.RANDOM_VALUE * randf())

func __get_next_tile_from_path(path): #TODO - move to helper
    if path.size() < 2:
        return null

    return self.bag.abstract_map.get_field(path[1])