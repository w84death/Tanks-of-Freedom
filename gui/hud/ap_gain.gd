
var bag

func _init_bag(bag):
	self.bag = bag

func update():
	self.bag.controllers.hud_panel_controller.info_panel.set_ap_gain(self.__calculate_gain())

func __calculate_gain():
	var total_ap_gain = 0
	var current_player = self.bag.controllers.action_controller.current_player

	#TODO WrmZ - investigate this (refreshing buildings - this should be done once)
	self.bag.positions.refresh_buildings()
	var buildings = self.bag.positions.get_player_buildings(current_player)
	for pos in buildings:
			total_ap_gain = total_ap_gain + buildings[pos].bonus_ap

	return total_ap_gain