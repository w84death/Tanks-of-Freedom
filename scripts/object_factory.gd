
var red_tank_template = preload('res://units/tank_red.tscn')
var blue_tank_template = preload('res://units/tank_blue.tscn')
var red_soldier_template = preload('res://units/soldier_red.tscn')
var blue_soldier_template = preload('res://units/soldier_blue.tscn')
var red_helicopter_template = preload('res://units/helicopter_red.tscn')
var blue_helicopter_template = preload('res://units/helicopter_blue.tscn')

var player_blue = 0
var player_red = 1

func build_unit(type, player):
	if type == 0:
		return self.build_soldier(player)
	if type == 1:
		return self.build_tank(player)
	if type == 2:
		return self.build_helicopter(player)
	return null
	
func build_tank(player):
	if (player == player_blue):
		return blue_tank_template.instance()
	if (player == player_red):
		return red_tank_template.instance()
		
func build_soldier(player):
	if (player == player_blue):
		return blue_soldier_template.instance()
	if (player == player_red):
		return red_soldier_template.instance()

func build_helicopter(player):
	if (player == player_blue):
		return blue_helicopter_template.instance()
	if (player == player_red):
		return red_helicopter_template.instance()
