var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(27, 26), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_INTRO_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(11, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(11, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(18, 16), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(21, 24), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_INTRO_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(27, 26), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'unlock', 'details' : {}},
    ],

    'app_crossroad' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(15, 11), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_CROSSROAD_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_CROSSROAD_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'cap_towers' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_TOWERS_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_12_TOWERS_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
        {'action' : 'win', 'details' : {'player' : 1}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

    'app_crossroad' : {
        'type' : 'move',
        'story' : 'app_crossroad',
        'details' : {
            'fields' : [
                Vector2(15, 11),
                Vector2(15, 12),
                Vector2(15, 13),
                Vector2(15, 14),
                Vector2(16, 14),
                Vector2(14, 12),
                Vector2(14, 13),
                Vector2(14, 14),
            ],
            'player' : 1
            },
        'one_off' : true,
        'suspended': true
    },

    'cap_towers' : {'type' : 'domination', 'story' : 'cap_towers', 'details' : { 'amount' : 4, 'list' : [Vector2(11, 3), Vector2(11, 13), Vector2(18, 16), Vector2(21, 24)], 'player' : 1 }, 'one_off' : true},
}
