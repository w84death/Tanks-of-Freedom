var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_INTRO_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_INTRO_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_INTRO_4', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'turn3' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(6, 13), 'unit' : 'tank', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(6, 14), 'unit' : 'tank', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(6, 15), 'unit' : 'soldier', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(6, 16), 'unit' : 'soldier', 'side' : 'blue'}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_TURN3_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_TURN3_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_TURN3_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'app_half_way' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(11, 27), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_13_HALF_WAY', 'portrait' : 'soldier_red', 'name' : 'ACTOR_SCOUT', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(14, 15), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

    'turn3' : {'type' : 'turn', 'story' : 'turn3', 'details' : { 'turn' : 3 }, 'one_off' : true},

    'app_half_way' : {
        'type' : 'move',
        'story' : 'app_half_way',
        'details' : {
            'fields' : [
                Vector2(12, 15),
                Vector2(12, 16),
                Vector2(12, 17),
                Vector2(12, 18),
                Vector2(13, 15),
                Vector2(13, 16),
                Vector2(13, 17),
                Vector2(13, 18),
                Vector2(14, 15),
                Vector2(14, 16),
                Vector2(14, 17),
                Vector2(14, 18),
                Vector2(15, 15),
                Vector2(15, 16),
                Vector2(15, 17),
                Vector2(15, 18)
            ],
            'player' : 1
        },
        'one_off' : true
    },
}
