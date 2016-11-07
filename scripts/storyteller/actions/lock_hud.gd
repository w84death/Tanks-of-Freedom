extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    self.bag.root.hud_controller.lock_hud()
    self.bag.root.hud_controller.hud_panel_anchor_top_right.hide()
    self.bag.root.hud.get_node("top_center").hide()
    self.bag.root.hud_controller.show_cinematic_camera()
    self.bag.fog_controller.toggle_fog()
    self.bag.root.selector.hide()

    var unit
    for unit_position in self.bag.positions.all_units:
        unit = self.bag.positions.all_units[unit_position]
        unit.health_bar.hide()
        unit.icon_shield.hide()

    self.bag.timers.set_timeout(0.55, self, "hide_bottom_elements")

func hide_bottom_elements():
    self.bag.root.hud_controller.cinematic_camera.get_node("bottom/bottom_block/progress").hide()
    self.bag.root.hud_controller.cinematic_camera.get_node("bottom/bottom_block/wait").hide()
