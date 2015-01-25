
var root_node
var action_controller

var end_turn_button

var hud_unit
var hud_unit_life
var hud_unit_attack
var hud_unit_ap
var hud_unit_plain
var hud_unit_road
var hud_unit_river

var hud_building

func init_root(root, action_controller_object):
	root_node = root
	action_controller = action_controller_object
	end_turn_button = root.get_node("/root/game/GUI/turn_card/end_turn")
	end_turn_button.connect("pressed", action_controller, "end_turn")
	
	hud_unit = root.get_node("/root/game/GUI/bottom_center/unit_card")
	hud_unit_life = hud_unit.get_node("life")
	hud_unit_attack = hud_unit.get_node("attack")
	hud_unit_ap = hud_unit.get_node("action_points")
	hud_unit_plain = hud_unit.get_node("plain")
	hud_unit_road = hud_unit.get_node("road")
	hud_unit_river = hud_unit.get_node("river")
	
	hud_building = root.get_node("/root/game/GUI/bottom_center/building_card")

func show_unit_card(unit):
	self.update_unit_card(unit.get_stats())
	hud_unit.show()

func update_unit_card(stats):
	hud_unit_life.set_text(str(stats.life))
	hud_unit_attack.set_text(str(stats.attack))
	hud_unit_ap.set_text(str(stats.ap))
	hud_unit_plain.set_text(str(stats.plain))
	hud_unit_road.set_text(str(stats.road))
	hud_unit_river.set_text(str(stats.river))
	
func clear_unit_card():
	hud_unit.hide()
	
func show_building_card(building):
	hud_building.show()
	
func clear_building_card():
	hud_building.hide()
	