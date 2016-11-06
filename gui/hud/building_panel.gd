var building_panel

var building_panel_units_dock
var building_panel_units_dock_button

var build_card_template = preload("res://gui/hud/build_card.gd")
var build_card

var building = null
var name_label

func bind(hud_panel):
    self.building_panel = hud_panel.get_node('building_panel')
    self.name_label = self.building_panel.get_node('building_name')
    self.build_card = self.build_card_template.new()
    self.build_card.bind(self.building_panel)

func bind_building(building_object, player_ap):
    var unit_spawned = building_object.spawn_unit(building_object.player)
    self.building = building_object
    self.name_label.set_text(tr('LABEL_BUILDING_' + building_object.get_building_name()))
    self.build_card.fill_card(unit_spawned, building.get_required_ap(), player_ap, building.spawn_field)
    unit_spawned.queue_free()

func bind_spawn_unit(controller, method_name):
    self.build_card.bind_spawn_unit(controller, method_name)

func unbind_building():
    self.building = null

func show():
    self.building_panel.show()

func hide():
    self.building_panel.hide()