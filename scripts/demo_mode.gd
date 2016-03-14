
var root
var demo_timer

func init_root(root_node):
    self.root = root_node
    self.demo_timer = root_node.get_node('DemoTimer')
    self.demo_timer.inject_root(root_node)

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
    var map_num = randi() % self.root.bag.map_list.maps.size()
    var keys = self.root.bag.map_list.maps.keys()
    return keys[map_num]