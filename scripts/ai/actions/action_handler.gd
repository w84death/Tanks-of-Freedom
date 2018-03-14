extends "res://scripts/bag_aware.gd"

var handlers = []

func _initialize():
    self.handlers = {
        "capture" : preload('res://scripts/ai/actions/handlers/capture.gd').new(self.bag),
        "move"    : preload('res://scripts/ai/actions/handlers/move.gd').new(self.bag),
        "attack"  : preload('res://scripts/ai/actions/handlers/attack.gd').new(self.bag),
        "spawn"   : preload('res://scripts/ai/actions/handlers/spawn.gd').new(self.bag),
        "void"    : preload('res://scripts/ai/actions/handlers/void.gd').new(self.bag)
    }

func execute(action):
    return self.handlers[action.type].execute(action)

func __choose_handler(action): # TODO - refactor this
    if action.type == "spawn":
        return "spawn"

    var next_tile = self.__get_next_tile_from_path(action.path)
    if next_tile != null:
        if (next_tile.object == null):
            return "move"
        else:
            if next_tile.has_capturable_building(action.unit):
                return "capture"
            elif next_tile.has_attackable_enemy(action.unit):
                return "attack"

    return "void"

func __get_next_tile_from_path(path): #TODO - move to helper
    if path.size() < 2:
        return null

    return self.bag.abstract_map.get_field(path[1])