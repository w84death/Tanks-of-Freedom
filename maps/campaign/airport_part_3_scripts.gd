var stories = {
	'introduction' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(4, 12), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_INTRO_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_INTRO_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'unlock', 'details' : {}},
	],

	'turn2' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 1},
		{'action' : 'camera', 'details' : {'where' : Vector2(4, 12), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN2_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(9, 24), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN2_2', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(5, 4), 'zoom' : 2}, 'delay' : 1.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN2_3', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(4, 12), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	],

	'turn3' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 1},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN3_1', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN3_2', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'unlock', 'details' : {}},
	],

	'turn4' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 1},
		{'action' : 'camera', 'details' : {'where' : Vector2(25, 26), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'spawn', 'details' : {'where' : Vector2(24, 28), 'unit' : 'soldier', 'side' : 'red'}, 'delay' : 1},
		{'action' : 'move', 'details' : {'who' : Vector2(24, 28), 'where' : Vector2(24, 27)}},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN4_1', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(25, 27), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN4_2', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(24, 26), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TURN4_3', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
		{'action' : 'attack', 'details' : {'who' : Vector2(24, 26), 'whom' : Vector2(24, 27)}, 'delay' : 1},
		{'action' : 'die', 'details' : {'who' : Vector2(24, 27)}, 'delay' : 2},
		{'action' : 'unlock', 'details' : {}},
	],

	'cap_airport' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 1},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'terrain_remove', 'details' : {'where'  : Vector2(15, 11), 'explosion' : true}, 'delay' : 0.5},
		{'action' : 'die', 'details' : {'who' : Vector2(14, 9)}},
		{'action' : 'die', 'details' : {'who' : Vector2(14, 10)}},
		{'action' : 'die', 'details' : {'who' : Vector2(14, 11)}, 'delay' : 2},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TRAP_1', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(23, 18), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'spawn', 'details' : {'where' : Vector2(22, 19), 'unit' : 'tank', 'side' : 'blue'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(22, 18), 'unit' : 'tank', 'side' : 'blue'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(22, 17), 'unit' : 'tank', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'camera', 'details' : {'where' : Vector2(23, 9), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'spawn', 'details' : {'where' : Vector2(22, 18), 'unit' : 'soldier', 'side' : 'blue'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(22, 17), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'message', 'details': {'text' : 'MISSION_14_TRAP_2', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	]
}

var triggers = {
	'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

	'turn2' : {'type' : 'turn', 'story' : 'turn2', 'details' : { 'turn' : 2 }, 'one_off' : true},

	'turn3' : {'type' : 'turn', 'story' : 'turn3', 'details' : { 'turn' : 3 }, 'one_off' : true},

	'turn4' : {'type' : 'turn', 'story' : 'turn4', 'details' : { 'turn' : 4 }, 'one_off' : true},

	'cap_airport' : {'type' : 'domination', 'story' : 'cap_airport', 'details' : { 'amount' : 1, 'list' : [Vector2(15, 10)], 'player' : 1 }, 'one_off' : true},
}

