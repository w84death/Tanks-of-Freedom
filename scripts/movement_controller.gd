var tile_types = StringArray([
	'plain','plain','plain','plain','plain','plain','plain','plain',
	'plain','plain','plain','plain','plain','road','road','road',
	'road','river','road',
	'road','road','road','road','road','road','road','road',
	'road','road','road','road','road','road','road','road',
	'road','road','road','road','road','road','road','road',
	'road','road','road','road',
	'river','river','river','river','river','river','river','river'
])

const DEFAULT_COST = 1

func move_object(from, to, action_cost=DEFAULT_COST):

	if self.has_enough_ap(from, action_cost):
		from.object.update_ap(from.object.ap - action_cost)

		to.object = from.object
		from.object = null
		to.object.set_pos_map(to.positionVAR)
		return true
	else:
		return false

func has_enough_ap(from, cost):
	if from.object.ap >= cost:
		return true
	else:
		return false

func can_move(from, to):
	if from.object.ap >= self.DEFAULT_COST:
		return true
	else:
		return false