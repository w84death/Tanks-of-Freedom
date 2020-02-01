var stories = {
	'introduction' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(9, 24), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_INTRO_1', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_INTRO_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(9, 24), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	],
	'factories' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(7, 20), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_FACTORIES', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(5, 4), 'zoom' : 2}, 'delay' : 1.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(23, 18), 'zoom' : 2}, 'delay' : 1.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(9, 24), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	],
	'app_airport' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_APP_AIRPORT', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
		{'action' : 'unlock', 'details' : {}},
	],
	'cap_airport' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_CAP_AIRPORT_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(23, 9), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_CAP_AIRPORT_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'unlock', 'details' : {}},
	],
	'buy_heli' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(15, 10), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_BUY_HELI_1', 'portrait' : 'heli_red', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_BUY_HELI_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_8_BUY_HELI_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'unlock', 'details' : {}},
	]
}

var triggers = {
	'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

	'factories' : {'type' : 'turn', 'story' : 'factories', 'details' : { 'turn' : 2 }, 'one_off' : true},

	'app_airport' : {
		'type' : 'move',
		'story' : 'app_airport',
		'details' : {
			'fields' : [
				Vector2(14, 8),
				Vector2(14, 9),
				Vector2(14, 10),
				Vector2(14, 11),
				Vector2(14, 12),
				Vector2(15, 12),
				Vector2(16, 8),
				Vector2(16, 9),
				Vector2(16, 10),
				Vector2(16, 11),
				Vector2(16, 12),
				Vector2(17, 8),
				Vector2(17, 9),
				Vector2(17, 10),
				Vector2(17, 11),
				Vector2(17, 12)
			],
			'player' : 1
			},
		'one_off' : true
	},

	'cap_airport' : {'type' : 'domination', 'story' : 'cap_airport', 'details' : { 'amount' : 1, 'list' : [Vector2(15, 10)], 'player' : 1 }, 'one_off' : true},

	'buy_heli' : {'type' : 'deploy', 'story' : 'buy_heli', 'details' : { 'player' : 1, 'amount': 1, 'type': 'heli' }, 'one_off' : true},
}
