var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(5, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 14), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_3', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(10, 13), 'unit' : 'soldier', 'side' : 'blue'}, 'delay': 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_4', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
        {'action' : 'move', 'details' : {'who' : Vector2(10, 13), 'where' : Vector2(9, 13)}},
        {'action' : 'move', 'details' : {'who' : Vector2(9, 13), 'where' : Vector2(8, 13)}, 'delay' : 1},
        {'action' : 'spawn', 'details' : {'where' : Vector2(7, 15), 'unit' : 'tank', 'side' : 'red'}, 'delay': 0.5},
        {'action' : 'move', 'details' : {'who' : Vector2(7, 15), 'where' : Vector2(7, 14)}},
        {'action' : 'move', 'details' : {'who' : Vector2(7, 14), 'where' : Vector2(7, 13)}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_5', 'portrait' : 'tank_red', 'name' : 'ACTOR_TANK_CREW', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_6', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
        {'action' : 'die', 'details' : {'who' : Vector2(8, 13)}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_INTRO_7', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(5, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'unlock', 'details' : {}},
    ],
    'cap_side_tower' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(28, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_TOWER_1', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(30, 5), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(30, 6), 'unit' : 'heli', 'side' : 'blue'}, 'delay': 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_TOWER_2', 'portrait' : 'heli_blue', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'app_red_hq' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 14), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_HQ_1', 'portrait' : 'tank_blue', 'name' : 'ACTOR_TANK_CREW', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_10_HQ_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(3, 25), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(3, 23), 'unit' : 'soldier', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(3, 24), 'unit' : 'soldier', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(2, 23), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(2, 24), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(2, 25), 'unit' : 'heli', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(2, 26), 'unit' : 'heli', 'side' : 'red'}, 'delay': 0.5},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

    'cap_side_tower' : {'type' : 'domination', 'story' : 'cap_side_tower', 'details' : { 'amount' : 1, 'list' : [Vector2(28, 3)], 'player' : 0 }, 'one_off' : true},

    'app_red_hq' : {
        'type' : 'move',
        'story' : 'app_red_hq',
        'details' : {
            'fields' : [
                Vector2(12, 28),
                Vector2(12, 27),
                Vector2(12, 26),
                Vector2(12, 25),
                Vector2(11, 28),
                Vector2(11, 27),
                Vector2(11, 26),
                Vector2(11, 25),
                Vector2(11, 24),
                Vector2(10, 28),
                Vector2(10, 27),
                Vector2(10, 26),
                Vector2(10, 25),
                Vector2(10, 24),
                Vector2(10, 23)
            ],
            'player' : 0
            },
        'one_off' : true
    }
}
