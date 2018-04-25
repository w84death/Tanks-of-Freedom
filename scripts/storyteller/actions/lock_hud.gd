extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    if not self.bag.root.is_locked_for_cpu:
        self.save_camera_zoom()
        self.bag.root.is_locked_for_cpu = true
        self.bag.root.hud_controller.lock_hud()
        self.bag.root.hud_controller.hud_panel_anchor_top_right.hide()
        self.bag.root.hud.get_node("top_center").hide()
        self.bag.root.hud_controller.show_cinematic_camera()
        self.bag.root.selector.hide()
        self.bag.root.hud_controller.cinematic_camera.get_node("bottom/progress").hide()
    self.bag.perform.pause = true
    self.bag.fog_controller.toggle_fog()

func save_camera_zoom():
    self.bag.storyteller.camera_zoom_level = self.bag.root.settings['camera_zoom']
