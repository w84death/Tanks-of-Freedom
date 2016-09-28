
const MATCH_LIMIT = 4

var bag

var online_menu_controller
var multiplayer_box_template = preload("res://scripts/controllers/multiplayer_box.gd")

var refresh_button

var match_boxes = {}

func _init_bag(bag):
    self.bag = bag
    self.online_menu_controller = self.bag.controllers.online_menu_controller

func bind():
    self.refresh_button = self.online_menu_controller.controls.get_node('horizontal2/refresh')

    self.refresh_button.connect("pressed", self, "_refresh_button_pressed")

    var match_boxes_wrapper = self.online_menu_controller.controls.get_node('matches')
    var new_box

    for i in range(1, self.MATCH_LIMIT + 1):
        new_box = self.multiplayer_box_template.new(self.bag, match_boxes_wrapper.get_node('match' + str(i)))
        self.match_boxes[i] = new_box
        new_box.hide()

func _refresh_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.refresh_matches_list()


func refresh_matches_list():
    return