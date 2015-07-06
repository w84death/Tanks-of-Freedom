
var root
var campaign_menu = preload("res://gui/menu_campaign.xscn").instance()

var current_campaign_map = 0

var back_button
var start_button
var prev_button
var next_button

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
    self.back_button = self.campaign_menu.get_node("control/dialog_controls/close")
    self.start_button = self.campaign_menu.get_node("control/dialog_controls/start_button")
    self.prev_button = self.campaign_menu.get_node("control/dialog_controls/prev_button")
    self.next_button = self.campaign_menu.get_node("control/dialog_controls/next_button")

    self.mission_num = self.campaign_menu.get_node("control/dialog_controls/title/mission_num")
    self.mission_name = self.campaign_menu.get_node("control/dialog_controls/title/mission_name")
    self.mission_description = self.campaign_menu.get_node("control/dialog_controls/Introduction")
    self.team = self.campaign_menu.get_node("control/dialog_controls/team")

    self.back_button.connect("pressed", self, "hide_campaign_menu")
    self.start_button.connect("pressed", self, "start_mission")
    self.prev_button.connect("pressed", self, "switch_to_prev")
    self.next_button.connect("pressed", self, "switch_to_next")

func attach_campaign_menu():
    self.root.dependency_container.controllers.menu_controller.add_child(self.campaign_menu)
    self.campaign_menu.hide()

func show_campaign_menu():
    self.manage_switch_buttons()
    self.campaign_menu.show()

func hide_campaign_menu():
    self.campaign_menu.hide()
    self.root.dependency_container.controllers.menu_controller.control_node.show()

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

    if self.current_campaign_map == 0:
        self.button_enable_switch(prev_button,false)
    else:
        self.button_enable_switch(prev_button,true)
    if (self.current_campaign_map + 1) == self.root.dependency_container.campaign.maps.size() || self.current_campaign_map == (campaign_progression + 1):
        self.button_enable_switch(next_button,false)
    else:
        self.button_enable_switch(next_button,true)

func button_enable_switch(button, show):
	var temp = null
	
	if show:
		button.set_disabled(false)
		button.get_node('title').show()
	else:
		button.set_disabled(true)
		button.get_node('title').hide()