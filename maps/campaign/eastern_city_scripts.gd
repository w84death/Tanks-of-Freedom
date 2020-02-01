var stories = {
	'introduction' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(4, 12), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_INTRO', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(4, 12), 'zoom' : 2}},
		{'action' : 'unlock', 'details' : {}},
	],
	'barracks' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}},
		{'action' : 'unlock', 'details' : {}},
	],
	'tipoff' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(6, 3), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_TIPOFF', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'unlock', 'details' : {}},
	],
	'barracks_claimed' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS_CAPTURED_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS_CAPTURED_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(7, 12), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'spawn', 'details' : {'where' : Vector2(6, 12), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'spawn', 'details' : {'where' : Vector2(8, 12), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS_CAPTURED_3', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS_TIP_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS_TIP_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_BARRACKS_TIP_3', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
		{'action' : 'unlock', 'details' : {}},
	],
	'hq_found' : [
		{'action' : 'lock', 'details' : {}, 'delay' : 0.5},
		{'action' : 'camera', 'details' : {'where' : Vector2(6, 3), 'zoom' : 2}, 'delay' : 0.5},
		{'action' : 'message', 'details': {'text' : 'MISSION_2_OFFICER_ALARM', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'right'}},
		{'action' : 'spawn', 'details' : {'where' : Vector2(7, 3), 'unit' : 'soldier', 'side' : 'red'}, 'delay' : 1},
		{'action' : 'spawn', 'details' : {'where' : Vector2(7, 4), 'unit' : 'soldier', 'side' : 'red'}, 'delay' : 1},
		{'action' : 'trigger', 'details' : {'name' : 'tipoff', 'suspended' : true}},
		{'action' : 'unlock', 'details' : {}},
	],
}

var triggers = {
	'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},
	'barracks' : {'type' : 'turn', 'story' : 'barracks', 'details' : { 'turn' : 2 }, 'one_off' : true},
	'tipoff' : {'type' : 'turn', 'story' : 'tipoff', 'details' : { 'turn' : 3 }, 'one_off' : true},
	'barracks_claimed' : {'type' : 'domination', 'story' : 'barracks_claimed', 'details' : { 'amount' : 1, 'list' : [Vector2(7, 13)], 'player' : 0 }, 'one_off' : true},
	'hq_found' : {'type' : 'move', 'story' : 'hq_found', 'details' : { 'fields' : [Vector2(5, 7), Vector2(7, 7), Vector2(8, 7), Vector2(9, 7), Vector2(5, 6), Vector2(6, 6), Vector2(7, 6), Vector2(8, 6), Vector2(9, 6), Vector2(3, 5), Vector2(5, 5), Vector2(6, 5), Vector2(7, 5), Vector2(8, 5), Vector2(9, 5), Vector2(3, 4), Vector2(4, 4), Vector2(5, 4), Vector2(6, 4), Vector2(7, 4), Vector2(8, 4), Vector2(3, 3), Vector2(4, 3), Vector2(7, 3), Vector2(8, 3)], 'player' : 0 }, 'one_off' : true},
}
