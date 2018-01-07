var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(19, 20), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_INTRO_1', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_GUARD', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(19, 16), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_INTRO_2', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SOLDIER', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_INTRO_3', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(12, 11), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_INTRO_4', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(19, 20), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'unlock', 'details' : {}},
    ],
    'left_claimed' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_LEFT_CLAIMED', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'right_claimed' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_RIGHT_CLAIMED', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SOLDIER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'entering_pass' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'despawn', 'details' : {'who' : Vector2(20, 10)}},
        {'action' : 'despawn', 'details' : {'who' : Vector2(20, 9)}},
        {'action' : 'despawn', 'details' : {'who' : Vector2(17, 10)}},
        {'action' : 'despawn', 'details' : {'who' : Vector2(17, 9)}},
        {'action' : 'camera', 'details' : {'where' : Vector2(19, 11), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(20, 10), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(20, 9), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(17, 10), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(17, 9), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_TRAP', 'portrait' : 'tank_red', 'name' : 'ACTOR_TANK_COMMANDER', 'side' : 'right'}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'entering_base' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(13, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_BASE_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_BASE_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'cap_towers' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(17, 1), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_TOWERS_1', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_OPERATOR', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_7_TOWERS_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

    'left_claimed' : {'type' : 'domination', 'story' : 'left_claimed', 'details' : { 'amount' : 1, 'list' : [Vector2(12, 11)], 'player' : 0 }, 'one_off' : true},

    'right_claimed' : {'type' : 'domination', 'story' : 'right_claimed', 'details' : { 'amount' : 1, 'list' : [Vector2(27, 10)], 'player' : 0 }, 'one_off' : true},

    'entering_pass' : {'type' : 'move', 'story' : 'entering_pass', 'details' : { 'fields' : [Vector2(19, 11), Vector2(19, 12), Vector2(19, 13), Vector2(18, 11), Vector2(18, 12), Vector2(18, 13)], 'player' : 0 }, 'one_off' : true},

    'entering_base' : {'type' : 'move', 'story' : 'entering_base', 'details' : { 'fields' : [Vector2(16, 5), Vector2(16, 6), Vector2(16, 7), Vector2(15, 5), Vector2(15, 6), Vector2(15, 7), Vector2(14, 5), Vector2(14, 6), Vector2(14, 7)], 'player' : 0 }, 'one_off' : true},

    'cap_towers' : {'type' : 'domination', 'story' : 'cap_towers', 'details' : { 'amount' : 2, 'list' : [Vector2(17, 1), Vector2(21, 3)], 'player' : 0 }, 'one_off' : true},
}
