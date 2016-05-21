const NON_WALKABLE = 999

var parent
var G = int(0)
var H = int(0)
var F = int(0)
var cost = int(1)
var walkable = bool(true)
var permament = bool(false)

func _init(cost, permament=false):
    if cost == NON_WALKABLE:
        self.walkable = false

    self.cost = cost
    self.permament = permament

func reset():
    if (self.permament == false):
        self.walkable = true
        self.cost = 1

    self.G = int(0)
    self.H = int(0)
    self.F = int(0)

func set_not_walkable():
	self.walkable = false
	self.cost = self.NON_WALKABLE