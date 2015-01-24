
var red_tank_template = preload('res://units/tank_red.xscn')

var player_blue = 0
var player_red = 0

func build_unit(type, player):
	if (type == 'tank'):
		return self.build_tank(player)
	return null
	
func build_tank(player):
	if (player == player_blue):
		return null;
	if (player == player_red):
		return red_tank_template.instance()