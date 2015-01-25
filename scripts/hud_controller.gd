
var root_node
var action_controller
var end_turn_button

func init_root(root, action_controller_object):
	root_node = root
	action_controller = action_controller_object
	end_turn_button = root.get_node("/root/game/GUI/turn_card/end_turn")
	end_turn_button.connect("pressed", action_controller, "end_turn")