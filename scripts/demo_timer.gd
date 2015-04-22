extends Timer

var timeout = 0
const INTERVAL = 15
const STATS_INTERVAL = 3
var root

var state = null

const INTRO = 1
const STATS = 2

func _process(delta):
	timeout += delta
	if timeout > self.__get_interval():
		self.stop()

		if state == INTRO:
			root.settings['turns_cap'] = 50
			root.settings['cpu_0'] = true
			root.settings['cpu_1'] = true
			root.load_map(get_map_name())
			root.load_menu()
			if !root.menu.is_hidden():
				root.toggle_menu()

			root.lock_for_demo()
			self.reset(STATS)

		else:
			root.restart_map()
			self.reset(INTRO)

func get_map_name():
	randomize()
	var names = ['river', 'city', 'country2']
	return names[randi() % names.size()]

func inject_root(root_obj):
	root = root_obj

func reset(state = INTRO):
	timeout = 0
	self.state = state

func __get_interval():
	if state == INTRO:
		return INTERVAL
	else:
		return STATS_INTERVAL

