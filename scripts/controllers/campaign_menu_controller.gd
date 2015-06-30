
var root
var campaign_menu = preload("res://gui/menu_campaign.xscn").instance()

var back_button

func init_root(root_node):
    self.root = root_node
    self.bind_campaign_menu()
    self.attach_campaign_menu()

func bind_campaign_menu():
    self.back_button = self.campaign_menu.get_node("control/dialog_controls/close")

    self.back_button.connect("pressed", self, "hide_campaign_menu")

func attach_campaign_menu():
    self.root.menu.add_child(self.campaign_menu)
    self.hide_campaign_menu()

func show_campaign_menu():
    self.campaign_menu.show()

func hide_campaign_menu():
    self.campaign_menu.hide()