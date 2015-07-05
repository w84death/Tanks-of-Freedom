
var building_panel

var building_panel_open_button
var building_panel_open_button_label
var building_panel_units_panel
var building_panel_upgrades_panel
var building_panel_units_panel_button
var building_panel_upgrades_panel_button

var build_card_template = preload("res://gui/hud/build_card.gd")
var build_card_0
var build_card_1

var building = null
var name_label

var background_extra_building_units
var background_extra_building_upgrades

func bind(hud_panel):
    self.building_panel = hud_panel.get_node('building_panel')

    self.building_panel_units_panel = self.building_panel.get_node('extras/units')
    self.building_panel_upgrades_panel = self.building_panel.get_node('extras/upgrades')
    self.building_panel_units_panel_button = self.building_panel.get_node('units_button')
    self.building_panel_upgrades_panel_button = self.building_panel.get_node('upgrades_button')
    self.name_label = self.building_panel.get_node('name')

    building_panel_units_panel_button.connect('pressed', self, 'toggle_build_card')
    building_panel_upgrades_panel_button.connect('pressed', self, 'toggle_research_card')

    background_extra_building_units = hud_panel.get_node('background/building_extra_panel/units')
    background_extra_building_upgrades = hud_panel.get_node('background/building_extra_panel/upgrades')

    self.build_card_0 = self.build_card_template.new()
    self.build_card_1 = self.build_card_template.new()

    self.build_card_0.bind(self.building_panel_units_panel.get_node('list/0'))
    self.build_card_1.bind(self.building_panel_units_panel.get_node('list/1'))

func bind_building(building_object, player_ap):
    var unit_spawned = building_object.spawn_unit(building_object.player)
    self.building = building_object
    self.hide_build_card()
    self.hide_research_card()
    self.name_label.set_text(building_object.get_building_name())
    self.build_card_0.show()
    self.build_card_0.fill_card(unit_spawned, building.get_required_ap(), player_ap)
    unit_spawned.queue_free()
    self.build_card_1.hide()

func bind_spawn_unit(controller, method_name):
    self.build_card_0.bind_spawn_unit(controller, method_name)

func unbind_building():
    self.hide_build_card()
    self.hide_research_card()

    self.building = null

func show():
    self.building_panel.show()

func hide():
    self.building_panel.hide()

func toggle_build_card():
    if self.building_panel_units_panel.is_hidden():
        self.show_build_card()
    else:
        self.hide_build_card()

func show_build_card():
    self.building_panel_units_panel.show()
    self.background_extra_building_units.show()

func hide_build_card():
    self.building_panel_units_panel.hide()
    self.background_extra_building_units.hide()

func toggle_research_card():
    if self.building_panel_upgrades_panel.is_hidden():
        self.show_research_card()
    else:
        self.hide_research_card()

func show_research_card():
    self.building_panel_upgrades_panel.show()
    self.background_extra_building_upgrades.show()

func hide_research_card():
    self.building_panel_upgrades_panel.hide()
    self.background_extra_building_upgrades.hide()
