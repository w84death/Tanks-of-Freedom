
var bag
var match_box

var match_panel = load("res://scripts/controllers/online/used_panel.gd").new()
var fill_panel = load("res://scripts/controllers/online/free_panel.gd").new()

func _init(bag, match_box):
	self.bag = bag
	self.match_box = match_box

	self.bind()

func bind():
	self.match_panel._init_bag(self.bag, self.match_box.get_node('used'))
	self.fill_panel._init_bag(self.bag, self.match_box.get_node('free'))

func show_match():
	self.match_panel.show()
	self.fill_panel.hide()

func show_fill():
	self.match_panel.hide()
	self.fill_panel.show()

func hide():
	self.match_panel.hide()
	self.fill_panel.hide()

func bind_match_data(data):
	self.match_panel.bind_match_data(data)
	self.show_match()

