extends Timer

var timeoutVAR = 0
const INTERVAL = 15
const STATS_INTERVAL = 3
var root

var state = null

const INTRO = 1
const STATS = 2
const NO_DELAY = 3

func _process(delta):
	if !is_stopped():
		timeoutVAR += delta
		if timeoutVAR > self.__get_interval():
			self.stop()
	
			if state == INTRO:
				if self.root.is_intro:
					self.root.load_menu()
				self.reset(STATS)
			else:
				self.reset(INTRO)
			self.root.bag.demo_mode.start_map()

func inject_root(root_obj):
	root = root_obj

func reset(state = INTRO):
	timeoutVAR = 0
	self.state = state

func __get_interval():
	if state == INTRO:
		return INTERVAL
	elif state == NO_DELAY:
		return 0
	else:
		return STATS_INTERVAL


