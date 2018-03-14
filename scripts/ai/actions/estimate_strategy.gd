extends "res://scripts/bag_aware.gd"

const RANDOM_VALUE = 0.005

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
    var t = [1,2,3]
    action.score = 0
    action.type = "void"

    if action.is_building_action():
        action.score = self.building_estimator.score(action)
        action.type = "spawn"
    else:
        var destination = action.destination
        if destination != null:
            if destination.group == 'waypoint' or destination.group == 'building':
                action.score = self.estimators[action.unit.type].score_capture(action)
                action.type = "capture"

            else:
                var last_tile = self.__get_last_tile_from_path(action.path)
                if last_tile.has_attackable_enemy(action.unit):
                    action.score = self.estimators[action.unit.type].score_attack(action)
                    action.type = "attack"

    self.__add_random(action)

func __add_random(action):
    if action.score > 0:
        randomize()
        action.score = action.score + (action.score * self.RANDOM_VALUE * randf())

func __get_last_tile_from_path(path): #TODO - move to helper (check if size is faster than duplicate / pop)
    if path.size() < 2:
        return null

    return self.bag.abstract_map.get_field(path[path.size() - 1])