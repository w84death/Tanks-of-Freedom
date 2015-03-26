# domination score
# unit moves
# turn time
# kills

# overall scores
var action_controller
var position_controller

var domination = [0, 0]
var moves = [0, 0]
var time = [0, 0]
var kills = [0, 0]
var total_time = ["00:00","00:00"]
var spawns = [0, 0]
var score = [0, 0]

func add_domination():
	var current_player = action_controller.current_player
	domination[current_player] = domination[current_player] + position_controller.get_player_buildings(current_player).size()

func add_spawn():
	var current_player = action_controller.current_player
	spawns[current_player] = spawns[current_player] + 1

func add_kills(current_player):
	action_controller.current_player
	kills[current_player] = kills[current_player] + 1

func add_moves():
	var current_player = action_controller.current_player
	moves[current_player] = moves[current_player] + 1

func __calculate_score():
	score[0] = (domination[0] * 3 + kills[0] * 2 + moves[0] + spawns[0]) * 10
	score[1] = (domination[1] * 3 + kills[1] * 2 + moves[1] + spawns[1]) * 10

	return score

func get_stats():
	score = self.__calculate_score()
	return {"domination": domination, "kills": kills, "time": total_time, "moves": moves, "spawns": spawns, "score" : score};

func _init(action_controller_object, position_controller_object):
	action_controller = action_controller_object
	position_controller = position_controller_object

