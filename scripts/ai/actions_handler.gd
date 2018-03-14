extends "res://scripts/bag_aware.gd"

var actions = []
var action = preload('actions/action.gd')

func add_action(unit, destination, ttl = self.action.DEFAULT_TTL):
    if self.get_action(unit, destination):
        return

    self.actions.append(self.create_action(unit, destination, ttl))

func create_action(unit, destination, ttl):
    return action.new(unit.position_on_map, destination, unit, unit.group, ttl)

func execute_best_action(action):
    if action != null:
        if self.bag.ai.ai_logger_enabled:
            self.bag.logger.store('<execute>' + action.__to_string())
        return self.bag.action_handler.execute(action)

    return false

func get_best_action(player):
    if self.actions.empty():
        return null
    if self.bag.ai.ai_logger_enabled:
        self.bag.logger.store('get best action for player %d' % player)
    self.reestimate_user_actions(player)
    var best = null
    self.actions.sort_custom(self, "__best_first")

    if self.bag.ai.ai_logger_enabled:
        for action in self.actions:
            if action.invalid:
                continue
            if action.unit.player == player:
                self.bag.logger.store(action.__to_string())

    for action in self.actions:
        if action.unit.player == player:
           best = action
           break
    if best == null or best.score == 0:
        return null

    return best

func reestimate_user_actions(player):
    for action in self.actions:
        if self.remove_if_faulty(action):
            continue

        if action.unit.player == player:
            if action.ttl <= 0:
                self.actions.erase(action)
            else:
                self.fix_path_if_faulty(action)
                self.bag.estimate.run(action)

func __best_first(a, b):
    if b != null and a.score > b.score:
        return true
    return false

func clear():
    self.actions.clear()
    self.actions = []

func remove(action):
    action.status = 1
    self.actions.erase(action)

func reset():
    self.actions.clear()

func fix_path_if_faulty(action): #TODO - this pobably should be done in action handler?
    if action.path.size() and action.unit.position_on_map != action.path[0]:
        action.fix_path()
        return true
    return false

func remove_if_faulty(action):
    var wr = weakref(action.unit)
    if !wr.get_ref() or (action.type != "spawn" and action.type != null and action.unit.life == 0): #WTF?
        self.actions.erase(action)
        return true
    return false

func remove_actions_for_unit(unit):
    var actions_to_erase = []
    for action in self.actions:
        if action.unit == unit or action.destination == unit:
            action.invalid = true
            actions_to_erase.append(action)

    for action in actions_to_erase:
        self.actions.erase(action)

func get_action(unit, destination):
    for action in self.actions:
        if action.unit == unit && action.destination == destination:
            return true

    return false


