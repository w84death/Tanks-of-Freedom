
var building_panel

var building_panel_open_button
var building_panel_open_button_label
var building_panel_units_panel
var building_panel_upgrades_panel
var building_panel_units_panel_button
var building_panel_upgrades_panel_button

var building = null

var background_extra_building_units
var background_extra_building_upgrades

func bind(hud_panel):
    self.building_panel = hud_panel.get_node('building_panel')

    building_panel_units_panel = self.building_panel.get_node('extras/units')
    building_panel_upgrades_panel = self.building_panel.get_node('extras/upgrades')
    building_panel_units_panel_button = self.building_panel.get_node('units_button')
    building_panel_upgrades_panel_button = self.building_panel.get_node('upgrades_button')

    building_panel_units_panel_button.connect('pressed', self, 'toggle_build_card')
    building_panel_upgrades_panel_button.connect('pressed', self, 'toggle_research_card')

    background_extra_building_units = hud_panel.get_node('background/building_extra_panel/units')
    background_extra_building_upgrades = hud_panel.get_node('background/building_extra_panel/upgrades')

func bind_building(building_object):
    self.hide_build_card()
    self.hide_research_card()

    self.building = building_object

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