const NON_WALKABLE = 999

var parent
var G = 0
var H = 0
var F = 0
var cost
var walkable = true

func _init(cost):
	if cost == NON_WALKABLE:
		self.walkable = false

	self.cost = cost