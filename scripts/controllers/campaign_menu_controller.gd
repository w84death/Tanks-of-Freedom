
var root
var campaign_menu = preload("res://gui/menu_campaign.xscn").instance()

var current_campaign_map = 0

var back_button
var start_button
var prev_button
var next_button
var difficulty_button
var difficulty_label

var mission_num
var mission_name
var mission_description
var team

func init_root(root_node):
    self.root = root_node
    self.bind_campaign_menu()
    self.attach_campaign_menu()
    self.current_campaign_map = self.root.dependency_container.campaign.get_campaign_progress() + 1
    if self.current_campaign_map == self.root.dependency_container.campaign.maps.size():
        self.current_campaign_map = self.current_campaign_map - 1
    self.fill_mission_data(self.current_campaign_map)
    self.manage_switch_buttons()

func bind_campaign_menu():
    self.back_button = self.campaign_menu.get_node("bottom/control/dialog_controls/close")
    self.start_button = self.campaign_menu.get_node("bottom/control/dialog_controls/start_button")
    self.prev_button = self.campaign_menu.get_node("bottom/control/dialog_controls/prev_button")
    self.next_button = self.campaign_menu.get_node("bottom/control/dialog_controls/next_button")
    self.difficulty_button = self.campaign_menu.get_node('middle/control/dialog_controls/difficulty_button')
    self.mission_num = self.campaign_menu.get_node("middle/control/dialog_controls/mission_num")
    self.difficulty_label = difficulty_button.get_node("Label")

    self.mission_name = self.campaign_menu.get_node("middle/control/dialog_controls/mission_name")
    self.mission_description = self.campaign_menu.get_node("middle/control/dialog_controls/Introduction")
    self.team = self.campaign_menu.get_node("middle/control/dialog_controls/team")

    self.back_button.connect("pressed", self, "_back_button_pressed")
    self.start_button.connect("pressed", self, "_start_button_pressed")
    self.prev_button.connect("pressed", self, "_prev_button_pressed")
    self.next_button.connect("pressed", self, "_next_button_pressed")
    self.difficulty_button.connect("pressed", self, "_difficulty_button_pressed")

func _back_button_pressed():
    self.root.sound_controller.play('menu')
    self.hide_campaign_menu()
    self.root.menu.campaign_button.grab_focus()
func _start_button_pressed():
    self.root.sound_controller.play('menu')
    self.start_mission()
func _prev_button_pressed():
    self.root.sound_controller.play('menu')
    self.switch_to_prev()
func _next_button_pressed():
    self.root.sound_controller.play('menu')
    self.switch_to_next()
func _difficulty_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.settings['easy_mode'] = not self.root.settings['easy_mode']
    self.manage_switch_buttons()

func attach_campaign_menu():
    self.root.dependency_container.controllers.menu_controller.add_child(self.campaign_menu)
    self.campaign_menu.hide()

func show_campaign_menu():
    self.manage_switch_buttons()
    self.campaign_menu.show()

func hide_campaign_menu():
    self.root.menu.refresh_buttons_labels()
    self.campaign_menu.hide()
    self.root.dependency_container.controllers.menu_controller.show_control_nodes()
    self.root.write_settings_to_file()

func fill_mission_data(mission_num):
    if mission_num < 0 || mission_num > self.root.dependency_container.campaign.maps.size() - 1:
        return

    self.current_campaign_map = mission_num
    self.set_mission_num(mission_num + 1)
    self.set_mission_name(self.root.dependency_container.campaign.get_map_name(mission_num))
    self.set_mission_description(self.root.dependency_container.campaign.get_map_description(mission_num))
    self.set_team(self.root.dependency_container.campaign.get_map_player(mission_num))
    self.manage_switch_buttons()

func set_mission_num(number):
    self.mission_num.set_text(str(number))

func set_mission_name(name):
    self.mission_name.set_text(name)

func set_mission_description(description):
    self.mission_description.set_text(description)

func set_team(team):
	self.team.set_frame(team)

func start_mission():
    self.root.load_map(self.current_campaign_map, false)
    self.hide_campaign_menu()
    self.root.toggle_menu()

func switch_to_prev():
    if self.current_campaign_map > 0:
        self.current_campaign_map = self.current_campaign_map - 1
        self.fill_mission_data(self.current_campaign_map)

func switch_to_next():
    if self.current_campaign_map < (self.root.dependency_container.campaign.maps.size() - 1):
        self.current_campaign_map = self.current_campaign_map + 1
        self.fill_mission_data(self.current_campaign_map)

func manage_switch_buttons():
    var campaign_progression = self.root.dependency_container.campaign.get_campaign_progress()
    var grab_next_button = false

    if self.current_campaign_map == 0:
        if self.prev_button.has_focus():
            grab_next_button = true
            self.start_button.grab_focus()
        self.button_enable_switch(prev_button,false)
    else:
        self.button_enable_switch(prev_button,true)

    if (self.current_campaign_map + 1) == self.root.dependency_container.campaign.maps.size() || self.current_campaign_map == (campaign_progression + 1):
        if self.next_button.has_focus():
            if not self.prev_button.is_disabled():
                self.prev_button.grab_focus()
            else:
                self.start_button.grab_focus()
        self.button_enable_switch(next_button,false)
    else:
        self.button_enable_switch(next_button,true)
        if grab_next_button:
            self.next_button.grab_focus()

    if self.root.settings['easy_mode']:
        difficulty_label.set_text('EASY')
    else:
        difficulty_label.set_text('NORMAL')

func button_enable_switch(button, show):
	var temp = null

	if show:
		button.set_disabled(false)
		button.get_node('title').show()
	else:
		button.set_disabled(true)
		button.get_node('title').hide()