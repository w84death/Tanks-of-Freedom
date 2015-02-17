var parent
var G = 0
var H = 0
var F = 0
var cost
var walkable = true

func _init(cost):
	if cost == 999:
		self.walkable = false

	self.cost = cost