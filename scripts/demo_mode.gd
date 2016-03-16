
var root
var bag
var demo_timer

func _init_bag(bag):
    self.bag = bag
    self.root = self.bag.root
    self.demo_timer = self.root.get_node('DemoTimer')
    self.demo_timer.inject_root(self.root)

func start_demo_mode(delay=true):
    if delay:
        self.demo_timer.reset()
    else:
        self.demo_timer.reset(self.demo_timer.NO_DELAY)
    self.demo_timer.start()

func start_map():
    self.root.settings['turns_cap'] = 50
    self.root.settings['cpu_0'] = true
    self.root.settings['cpu_1'] = true
    self.root.load_map('workshop', self.get_random_map())
    if !self.root.menu.is_hidden():
        self.root.toggle_menu()
    self.root.lock_for_demo()

func get_random_map():
    randomize()
    var map_num = randi() % self.bag.map_list.maps.size()
    var keys = self.bag.map_list.maps.keys()
    return keys[map_num]