var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(5, 22), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_INTRO_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(22, 24), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(10, 17), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_INTRO_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(5, 22), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'unlock', 'details' : {}},
    ],

    'turn2' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN2_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN2_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'turn10' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN10_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN10_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'turn18' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN15_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(26, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(27, 5), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(27, 6), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(27, 7), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(27, 8), 'unit' : 'heli', 'side' : 'blue'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN15_2', 'portrait' : 'heli_blue', 'name' : 'ACTOR_PILOT', 'side' : 'right'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'turn22' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN18_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'turn26' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_TURN20_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'win', 'details' : {'player' : 0}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'app_blue_hq' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(22, 24), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_9_APP_HQ', 'portrait' : 'tank_red', 'name' : 'ACTOR_TANK_CREW', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},

    'turn2' : {'type' : 'turn', 'story' : 'turn2', 'details' : { 'turn' : 2 }, 'one_off' : true},

    'turn10' : {'type' : 'turn', 'story' : 'turn10', 'details' : { 'turn' : 10 }, 'one_off' : true},

    'turn18' : {'type' : 'turn', 'story' : 'turn18', 'details' : { 'turn' : 18 }, 'one_off' : true},

    'turn22' : {'type' : 'turn', 'story' : 'turn22', 'details' : { 'turn' : 22 }, 'one_off' : true},

    'turn26' : {'type' : 'turn', 'story' : 'turn26', 'details' : { 'turn' : 26 }, 'one_off' : true},

    'app_blue_hq' : {'type' : 'move', 'story' : 'app_blue_hq', 'details' : { 'fields' : [Vector2(20, 22), Vector2(21, 22), Vector2(22, 22), Vector2(23, 22), Vector2(24, 22), Vector2(22, 23), Vector2(23, 23), Vector2(24, 23), Vector2(23, 24), Vector2(24, 24), Vector2(23, 25), Vector2(24, 25)], 'player' : 1 }, 'one_off' : true},
}
