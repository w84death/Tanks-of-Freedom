var list = []

const NONE = 0
const GAME_ENDED = 1
const CLEAR_ACTIVE_FIELD = 2
const HAS_TERRAIN = 3
const ACTIVATE_FIELD = 4
const MOVE_UNIT = 5
const NO_MOVES = 6
const BATTLE = 7
const CAPTURE = 8
const CAPTURE_AND_WIN = 9
const UNEXPECTED = 10
const CANNOT_DO = 11

func add(code, status, msg):
	self.list.insert(code, {'status': status, "msg": msg})

func _init():
	self.add(self.NONE, 0, "-")
	self.add(self.GAME_ENDED, 0, "game ends")
	self.add(self.CLEAR_ACTIVE_FIELD, 0, "clear active field")
	self.add(self.HAS_TERRAIN, 0, "has terrain")
	self.add(self.ACTIVATE_FIELD, 0, "activate field")
	self.add(self.MOVE_UNIT, 1, "move unit")
	self.add(self.NO_MOVES, 0, "no moves")
	self.add(self.BATTLE, 1, "battle")
	self.add(self.CAPTURE, 1, "capture building")
	self.add(self.CAPTURE_AND_WIN, 1, "capture hq")
	self.add(self.UNEXPECTED, 0, "unexpected")
	self.add(self.CANNOT_DO, 0, "cannot do action")

