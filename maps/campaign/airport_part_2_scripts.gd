var stories = {
	'introduction' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(25, 26), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_11_INTRO_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_11_INTRO_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(25, 26), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	],

	'turn3' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(11, 26), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'spawn', 'details' : {'where' : Vector2(14, 27), 'unit' : 'heli', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'move', 'details' : {'who' : Vector2(14, 27), 'where' : Vector2(13, 27)}},
		{'action' : 'move', 'details' : {'who' : Vector2(13, 27), 'where' : Vector2(12, 27)}, 'delay' : 1},
		{'action' : 'message', 'details': {'text' : 'MISSION_11_RECON_1', 'portrait' : 'heli_blue', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(11, 23), 'unit' : 'tank', 'side' : 'red'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(12, 23), 'unit' : 'tank', 'side' : 'red'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(12, 24), 'unit' : 'tank', 'side' : 'red'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(10, 23), 'unit' : 'soldier', 'side' : 'red'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(10, 24), 'unit' : 'soldier', 'side' : 'red'}, 'delay' : 1},
		{'action' : 'message', 'details': {'text' : 'MISSION_11_RECON_2', 'portrait' : 'heli_blue', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
		{'action' : 'move', 'details' : {'who' : Vector2(12, 27), 'where' : Vector2(13, 27)}},
		{'action' : 'move', 'details' : {'who' : Vector2(13, 27), 'where' : Vector2(14, 27)}, 'delay' : 1},
		{'action' : 'despawn', 'details' : {'who' : Vector2(14, 27)}},
		{'action' : 'camera', 'details' : {'where' : Vector2(25, 26), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	],

	'cap_tower' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 20), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_11_CAP_TOWER', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
		{'action' : 'trigger', 'details' : {'name' : 'bring_tank', 'suspended' : false}},
		{'action' : 'unlock', 'details' : {}},
	],

	'bring_tank' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 20), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_11_TANK', 'portrait' : 'tank_blue', 'name' : 'ACTOR_TANK_COMMANDER', 'side' : 'left'}},
		{'action' : 'terrain_remove', 'details' : {'where'  : Vector2(14, 21), 'explosion' : true}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	]
}

var triggers = {
	'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

	'turn3' : {'type' : 'turn', 'story' : 'turn3', 'details' : { 'turn' : 3 }, 'one_off' : true},

	'cap_tower' : {'type' : 'domination', 'story' : 'cap_tower', 'details' : { 'amount' : 1, 'list' : [Vector2(15, 20)], 'player' : 0 }, 'one_off' : true},

	'bring_tank' : {
		'type' : 'move',
		'story' : 'bring_tank',
		'details' : {
			'fields' : [
				Vector2(14, 20)
			],
			'player' : 0
			},
		'one_off' : true,
		'suspended': true
	},
}

