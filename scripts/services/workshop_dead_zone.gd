
var root
var ready = false
var screen_size

var file_panel_size = Vector2(460, 240)
var file_panel_top_offset = 108
var bottom_panel_size = Vector2(580, 200)
var bottom_panel_offset = 585
var popup_size = Vector2(280, 220)
var popup_top_offset = 245

func init_root(root_node):
    self.root = root_node
    self.screen_size = OS.get_video_mode_size()
    self.ready = true


func is_dead_zone(x, y):
    if not self.ready:
        return false

    if self.check_if_in_zone(x, y, self.root.dependency_container.controllers.workshop_gui_controller.file_panel.position.y - self.file_panel_top_offset, self.file_panel_size):
        return true

    if self.check_if_in_zone(x, y, self.bottom_panel_offset, self.bottom_panel_size):
        return true

    if self.root.dependency_container.controllers.workshop_gui_controller.toolbox_panel.toolbox_panel.is_visible():
        return true

    if self.root.dependency_container.controllers.workshop_gui_controller.building_blocks_panel.building_block_panel.is_visible():
        return true

    if self.root.dependency_container.controllers.workshop_gui_controller.file_panel.is_map_picker_visible():
        return true

    if self.root.dependency_container.controllers.workshop_gui_controller.file_panel.is_game_setup_visible():
        return true

    return false


func check_if_in_zone(x, y, top_offset, box, side_offset=null):
    var middle = self.screen_size.x / 2;
    var left_edge = middle - box.x / 2;
    var right_edge = middle + box.x / 2;
    if side_offset != null:
        left_edge = left_edge + side_offset
        right_edge = right_edge + side_offset
    var top_edge = top_offset
    var bottom_edge = top_offset + box.y
    if x > left_edge && x < right_edge && y > top_edge && y < bottom_edge:
        return true
    return false
