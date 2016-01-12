
var root
var ready = false
var screen_size

var top_hud_size = Vector2(166, 65)
var bottom_hud_size = Vector2(696, 83)
var selected_panel_size = Vector2(350, 83)


var unit_panel_size = Vector2(10, 10)
var building_build_panel_size = Vector2(380, 90)
var building_build_panel_offset = -170
var building_research_panel_size = Vector2(10, 10)
var building_research_panel_offset = 10
var popup_size = Vector2(280, 220)
var popup_top_offset = 245

func init_root(root_node):
    var screen_width = Globals.get("display/width")
    var screen_height = Globals.get("display/height")

    self.root = root_node
    self.screen_size = Vector2(screen_width, screen_height)
    self.ready = true

func is_dead_zone(x, y):
    if not self.ready:
        return false

    if self.check_if_in_zone(x, y, 0, self.top_hud_size):
        return true

    if self.root.hud_controller.hud_message_card.is_visible():
        if self.check_if_in_zone(x, y, self.popup_top_offset, self.popup_size):
            return true

    if self.root.dependency_container.controllers.hud_panel_controller.hud_panel.is_visible():
        if self.check_if_in_zone(x, y, self.screen_size.y - self.bottom_hud_size.y, self.bottom_hud_size):

            if not self.root.dependency_container.controllers.hud_panel_controller.building_panel.building_panel.is_visible() and not self.root.dependency_container.controllers.hud_panel_controller.unit_panel.unit_panel.is_visible() and self.check_if_in_zone(x, y, self.screen_size.y - self.selected_panel_size.y, self.selected_panel_size):
                return false
            return true


        #if self.root.dependency_container.controllers.hud_panel_controller.unit_panel.unit_panel_extras.is_visible():
        #    if self.check_if_in_zone(x, y, self.screen_size.y - (self.bottom_hud_size.y + self.unit_panel_size.y), self.unit_panel_size):
        #        return true
        #if self.root.dependency_container.controllers.hud_panel_controller.building_panel.building_panel.is_visible():
        #    if self.check_if_in_zone(x, y, self.screen_size.y - (self.bottom_hud_size.y + self.building_build_panel_size.y), self.building_build_panel_size):
        #        return true
        #if self.root.dependency_container.controllers.hud_panel_controller.building_panel.building_panel_upgrades_panel.is_visible():
        #    if self.check_if_in_zone(x, y, self.screen_size.y - (self.bottom_hud_size.y + self.building_research_panel_size.y), self.building_research_panel_size):
        #        return true

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