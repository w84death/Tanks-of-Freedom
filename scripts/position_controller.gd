var root_node
var buildings
var bunkers
var center

func init_root(root):
	root_node = root

	bunkers = {0: null, 1: null}
	get_bunkers()

func get_player_bunker_position(player):
	return bunkers[player].get_initial_pos()

func get_bunkers():
	buildings = root_node.get_tree().get_nodes_in_group("buildings")
	var row
	for building in buildings:
		if (building.get_name() == "BUNKER"):
			bunkers[building.get_player()] = building
