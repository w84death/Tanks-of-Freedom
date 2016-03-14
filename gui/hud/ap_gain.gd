
var root

func init_root(root_node):
    self.root = root_node

func update():
    var gain = self.calculate_gain()
    self.root.bag.controllers.hud_panel_controller.info_panel.set_ap_gain(gain)

func calculate_gain():
    var total_ap_gain = 0
    var current_player = self.root.bag.controllers.action_controller.current_player
    var buildings = self.root.get_tree().get_nodes_in_group("buildings")
    for building in buildings:
        if building.player == current_player:
            total_ap_gain = total_ap_gain + building.bonus_ap
    return total_ap_gain