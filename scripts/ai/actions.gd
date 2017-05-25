var actions = {}
var action = preload('actions/action.gd')
var estimate = preload('actions/estimate.gd').new()

func add_action(unit, destination):
    var action = self.create_action(unit, destination)
    action.score = self.estimate.run(action)
    if self.actions.has(action.score):
        action.score = action.score + floor(randf() * 20)

    self.actions[action.score] = action

func create_action(unit, destination):
    #print('create action :', unit.position_on_map , ' where:' , destination.position_on_map)
    return action.new(unit.position_on_map, destination, unit.get_instance_ID())

func execute_best_action():
    var action = self.get_best_action()

    if action != null:
        return action.execute()

    return false

func get_best_action():
    if self.actions.empty():
        return null
    return actions[self.__get_max_key(actions.keys())]

func clear():
    self.actions.clear()

func __get_max_key(keys):
    var max_key = -999
    for key in keys:
        if (key > max_key):
            max_key = key

    return max_key