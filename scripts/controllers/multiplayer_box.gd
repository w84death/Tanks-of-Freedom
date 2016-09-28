
var bag
var match_box

var match_panel
var fill_panel

func _init(bag, match_box):
    self.bag = bag
    self.match_box = match_box

    self.bind()

func bind():
    self.match_panel = self.match_box.get_node('used')
    self.fill_panel = self.match_box.get_node('free')

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
    print(data)
