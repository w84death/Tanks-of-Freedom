var actions = {}

func append_action(action, score):
	if actions.has(score):
		score = score + floor(randf() * 20)

	actions[score] = action

func execute_best_action():
	var action = self.get_best_action()
	if action != null:
		return action.execute()

	return false

func get_best_action():
	var size = actions.size()
	if (size > 0):
		return actions[self.__get_max_key(actions.keys())]
	return null

func clear():
	actions.clear()

func __get_max_key(keys):
	var max_key = -999
	for key in keys:
		if (key > max_key):
			max_key = key

	return max_key