extends "res://scripts/bag_aware.gd"

const MATCH_LIMIT = 4

var online_menu_controller
var middle_container
var controls
var background
var multiplayer_box_template = preload("res://scripts/controllers/online/multiplayer_box.gd")

var refresh_button
var help_button

var match_boxes = {}

func _initialize():
	self.online_menu_controller = self.bag.controllers.online_menu_controller

func bind():
	self.controls = self.online_menu_controller.controls
	self.refresh_button = self.controls.get_node('buttons/refresh')
	self.refresh_button.connect("pressed", self, "_refresh_button_pressed")

	self.help_button = self.controls.get_node('buttons/help')
	self.help_button.connect("pressed", self, "_help_button_pressed")

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

func _help_button_pressed():
	self.bag.root.sound_controller.play('menu')
	self.show_help()

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
	var i = 1
	if returned_request.has('data') and returned_request['data'].has('matches'):
		for matchVAR in returned_request['data']['matches']:
			self.match_boxes[i].bind_match_data(matchVAR)
			i = i+1
		if i <= self.MATCH_LIMIT:
			self.match_boxes[i].show_fill()
			i = i+1
		while i <= self.MATCH_LIMIT:
			self.match_boxes[i].hide()
			i = i+1
		self.refresh_matches_list_done()
		self.download_stock_maps()
	else:
		self.bag.message_popup.detach_panel()
		self.bag.message_popup.attach_panel(self.middle_container)
		self.bag.message_popup.fill_labels(tr('LABEL_REFRESHING_MATCHES'), tr('MSG_OPERATION_FAILED'), tr('LABEL_DONE'))
		self.bag.message_popup.connect(self, "refresh_matches_list_done")
		self.bag.message_popup.confirm_button.grab_focus()
		while i <= self.MATCH_LIMIT:
			self.match_boxes[i].hide()
			i = i+1

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

func show_help():
	var messages = [
		tr('TIP_ONLINE_HELP_1'),
		tr('TIP_ONLINE_HELP_2'),
	]
	self.controls.hide()
	self.background.hide()
	self.bag.message_big_popup.attach_panel(self.middle_container)
	self.bag.message_big_popup.fill_labels(tr('MSG_MULTIPLAYER_WELCOME'), messages, "LABEL_BACK")
	self.bag.message_big_popup.connect(self, "close_help")
	self.bag.message_big_popup.confirm_button.grab_focus()
	self.middle_container.show()

func close_help():
	self.bag.message_big_popup.detach_panel()
	self.controls.show()
	self.background.show()
	self.middle_container.hide()
	self.help_button.grab_focus()

func download_stock_maps():
	var stock_maps = [
		"CHEKLEEN",
		"7FDEXJYF",
		"VWUR37W4",
		"94EMKDXT",
		"7K93YLLW",
		"YMJHADWT",
	]

	for code in stock_maps:
		if not self.bag.map_list.has_remote_map(code):
			self.bag.online_maps.download_map_async_background(code)
			return