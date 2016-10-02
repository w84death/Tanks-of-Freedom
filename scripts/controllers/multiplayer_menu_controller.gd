
const MATCH_LIMIT = 4

var bag

var online_menu_controller
var middle_container
var controls
var background
var multiplayer_box_template = preload("res://scripts/controllers/online/multiplayer_box.gd")

var refresh_button

var match_boxes = {}

func _init_bag(bag):
    self.bag = bag
    self.online_menu_controller = self.bag.controllers.online_menu_controller

func bind():
    self.controls = self.online_menu_controller.controls
    self.refresh_button = self.controls.get_node('horizontal2/refresh')

    self.refresh_button.connect("pressed", self, "_refresh_button_pressed")

    var match_boxes_wrapper = self.controls.get_node('matches')
    var new_box

    for i in range(1, self.MATCH_LIMIT + 1):
        new_box = self.multiplayer_box_template.new(self.bag, match_boxes_wrapper.get_node('match' + str(i)))
        self.match_boxes[i] = new_box
        new_box.hide()

    self.middle_container = self.online_menu_controller.middle_container
    self.background = self.online_menu_controller.background

func _refresh_button_pressed():
    self.bag.root.sound_controller.play('menu')
    self.refresh_matches_list()

func refresh_matches_list():
    self.online_menu_controller.refreshed = true
    self.controls.hide()
    self.background.hide()
    self.bag.message_popup.attach_panel(self.middle_container)
    self.bag.message_popup.fill_labels(tr('LABEL_REFRESHING_MATCHES'), tr('TIP_REFRESHING_WAIT'), "")
    self.bag.message_popup.hide_button()
    self.middle_container.show()
    self.perform_refresh_list()

func perform_refresh_list():
    self.bag.online_multiplayer.get_matches_list(self, 'fill_matches_list_with_data')

func fill_matches_list_with_data(returned_request):
    if returned_request.has('data') and returned_request['data'].has('matches'):
        var i = 1
        for match in returned_request['data']['matches']:
            self.match_boxes[i].bind_match_data(match)
            i = i+1
        if i <= self.MATCH_LIMIT:
            self.match_boxes[i].show_fill()
    self.refresh_matches_list_done()

func refresh_matches_list_done():
    self.bag.message_popup.detach_panel()
    self.controls.show()
    self.background.show()
    self.middle_container.hide()
    self.refresh_button.grab_focus()


func has_match(code):
    for box in self.match_boxes:
        if self.match_boxes[box].match_panel.match_join_code == code:
            return true

    return false