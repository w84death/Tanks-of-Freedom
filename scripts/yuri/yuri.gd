extends "res://scripts/bag_aware.gd"

# copied a_star implementation to fix some issues
var pathfinder = preload("res://scripts/yuri/a_star.gd").new()

# actions collector for AI
var collector = preload("res://scripts/yuri/actions/collector.gd").new()

# executor for current action
var executor = preload("res://scripts/yuri/actions/egzekutor.gd").new()


# stored action with multiple steps to be executed
var current_action = null


# initialize stuf as needed
func _initialize():
    self.pathfinder._init_bag(self.bag)
    self.collector._init_bag(self.bag)
    self.executor._init_bag(self.bag)


# wrapper method to be compatible with previous AI
#
# @return bool - returns whether AI was able to perform an action
func start_do_ai(current_player, player_ap):
    return self._perform_ai_tick(current_player)

# reset AI to initial state
func reset():
    self.current_action = null


# method for performin a single tick of AI
# tick consists of optional action gathering and action execution
func _perform_ai_tick(current_player):
    if self.current_action == null:
        self._prepare_current_action(current_player)

    return self._execute_best_action()


# gathers available actions and picks the best one to become current action
func _prepare_current_action(current_player):
    var available_actions = self.collector.get_available_actions(current_player)

    if available_actions.size() > 0:
        self.current_action = self._get_best_action(available_actions)

# method for selecting best action from a collection
func _get_best_action(available_actions):
    available_actions.sort_custom(self, "_value_first_sort_comparator")

    return available_actions[0]

# action value comparator for sort
func _value_first_sort_comparator(a, b):
    if b != null and a.score > b.score:
        return true
    return false


# executes currently selected action
#
# @return bool - returns whether AI was able to perform an action
func _execute_best_action():
    if self.current_action == null:
        return false

    self.executor.execute(self.current_action)

    if not self.current_action.can_continue():
        self.current_action = null

    return true