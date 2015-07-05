
var root
var hud_panel = preload("res://gui/hud/hud_panel.xscn").instance()

var default_panel = null
var unit_panel = preload("res://gui/hud/unit_panel.gd").new()
var building_panel = preload("res://gui/hud/building_panel.gd").new()
var info_panel = preload("res://gui/hud/info_panel.gd").new()


func init_root(root_node):
	root = root_node
	self.bind_panels()

func bind_panels():
	self.default_panel = self.hud_panel.get_node('default_panel')
	self.unit_panel.bind(hud_panel)
	self.building_panel.bind(hud_panel)
	self.info_panel.bind(hud_panel)

func show_default_panel():
	default_panel.show()

func hide_default_panel():
	default_panel.hide()

func show_building_panel(building, player_ap):
	self.hide_default_panel()
	self.building_panel.bind_building(building, player_ap)
	self.building_panel.show()

func hide_building_panel():
	self.building_panel.hide()
	self.building_panel.unbind_building()
	self.show_default_panel()

func show_unit_panel(unit):
	self.hide_default_panel()
	self.unit_panel.bind_unit(unit)
	self.unit_panel.show()

func hide_unit_panel():
	self.unit_panel.hide()
	self.unit_panel.unbind_unit()
	self.show_default_panel()

func hide_panel():
	self.hud_panel.hide()

func show_panel():
	self.hud_panel.show()

func clear_panels():
	self.hide_unit_panel()
	self.hide_building_panel()