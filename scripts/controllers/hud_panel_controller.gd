
var root
var hud_panel = preload("res://gui/hud/hud_panel.xscn").instance()
var end_turn_panel_scene = preload("res://gui/hud/end_turn.tscn").instance()
var info_panel_scene = preload("res://gui/hud/turn_info.tscn").instance()
var zoom_panel_scene = preload("res://gui/hud/zoom_panel.tscn").instance()

var default_panel = null
var unit_panel = preload("res://gui/hud/unit_panel.gd").new()
var building_panel = preload("res://gui/hud/building_panel.gd").new()
var info_panel = preload("res://gui/hud/info_panel.gd").new()


func init_root(root_node):
	root = root_node
	self.default_panel = self.hud_panel.get_node('default_panel')
	self.unit_panel.bind(self.hud_panel)
	self.building_panel.bind(self.hud_panel)
	self.info_panel.bind(self.end_turn_panel_scene, self.info_panel_scene, self.zoom_panel_scene)

func bind_panels(card_anchor, end_anchor, info_anchor, zoom_anchor):
	card_anchor.add_child(self.hud_panel)
	end_anchor.add_child(self.end_turn_panel_scene)
	info_anchor.add_child(self.info_panel_scene)
	zoom_anchor.add_child(self.zoom_panel_scene)

func unbind_panels(card_anchor, end_anchor, info_anchor, zoom_anchor):
	card_anchor.remove_child(self.hud_panel)
	end_anchor.remove_child(self.end_turn_panel_scene)
	info_anchor.remove_child(self.info_panel_scene)
	zoom_anchor.remove_child(self.zoom_panel_scene)

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

func reset():
	self.info_panel.reset()
	self.clear_panels()