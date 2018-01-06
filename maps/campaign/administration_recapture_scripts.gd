var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(26, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_3', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_4', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_5', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(25, 10), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_6', 'portrait' : 'heli_blue', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_INTRO_7', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'app_old_base' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(19, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_APP_BASE', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'app_left_towers' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(18, 21), 'zoom' : 3}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_APP_TOWERS_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_APP_TOWERS_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'cap_left_towers' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(14, 21), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(13, 22), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(14, 22), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_APP_TOWERS_3', 'portrait' : 'heli_blue', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'patrol' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(6, 7), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(6, 7), 'unit' : 'soldier', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(6, 8), 'unit' : 'soldier', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(7, 7), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(7, 8), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_PATROL_1', 'portrait' : 'tank_red', 'name' : 'ACTOR_TANK_CREW', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_PATROL_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'right'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'app_red_hq' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'die', 'details' : {'who' : Vector2(7, 7)}},
        {'action' : 'die', 'details' : {'who' : Vector2(6, 7)}},
        {'action' : 'die', 'details' : {'who' : Vector2(6, 8)}},
        {'action' : 'die', 'details' : {'who' : Vector2(6, 9)}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(7, 7), 'unit' : 'soldier', 'side' : 'red'}, "delay" : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_RED_HQ_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_RED_HQ_2', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SOLDIER', 'side' : 'right'}},
        {'action' : 'move', 'details' : {'who' : Vector2(7, 7), 'where' : Vector2(6, 7)}},
        {'action' : 'move', 'details' : {'who' : Vector2(6, 7), 'where' : Vector2(6, 8)}},
        {'action' : 'move', 'details' : {'who' : Vector2(6, 8), 'where' : Vector2(6, 9)}},
        {'action' : 'despawn', 'details' : {'who' : Vector2(6, 9)}},
        {'action' : 'message', 'details': {'text' : 'MISSION_6_RED_HQ_3', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

    'app_old_base' : {'type' : 'move', 'story' : 'app_old_base', 'details' : { 'fields' : [Vector2(20, 4), Vector2(20, 6), Vector2(20, 7), Vector2(20, 8), Vector2(19, 4), Vector2(19, 7), Vector2(19, 8), Vector2(18, 4), Vector2(18, 5), Vector2(18, 6), Vector2(18, 7), Vector2(18, 8), Vector2(17, 7), Vector2(17, 8)], 'player' : 0 }, 'one_off' : true},

    'app_left_towers' :  {'type' : 'move', 'story' : 'app_left_towers', 'details' : { 'fields' : [Vector2(23, 18), Vector2(22, 18), Vector2(22, 21), Vector2(21, 18), Vector2(21, 19), Vector2(21, 20), Vector2(21, 21), Vector2(20, 18), Vector2(20, 19), Vector2(20, 20), Vector2(20, 21), Vector2(16, 19), Vector2(16, 20), Vector2(15, 19), Vector2(15, 20), Vector2(15, 21), Vector2(15, 22), Vector2(14, 19), Vector2(14, 20), Vector2(14, 22), Vector2(13, 19), Vector2(13, 20), Vector2(13, 21), Vector2(13, 22), Vector2(12, 19), Vector2(12, 20), Vector2(12, 21)], 'player' : 0 }, 'one_off' : true},

    'cap_left_towers' : {'type' : 'domination', 'story' : 'cap_left_towers', 'details' : { 'amount' : 2, 'list' : [Vector2(14, 21), Vector2(22, 20)], 'player' : 0 }, 'one_off' : true},

    'patrol' : {'type' : 'turn', 'story' : 'patrol', 'details' : { 'turn' : 5 }, 'one_off' : true},

    'app_red_hq' : {'type' : 'move', 'story' : 'app_red_hq', 'details' : { 'fields' : [Vector2(10, 7), Vector2(10, 8), Vector2(9, 7), Vector2(9, 8), Vector2(8, 7), Vector2(8, 8), Vector2(7, 7), Vector2(7, 8), Vector2(6, 7), Vector2(6, 8)], 'player' : 0 }, 'one_off' : true},
}
