var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(23, 4), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_OFFICER_INTRO_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_OFFICER_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(1, 12), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_OFFICER_INTRO_3', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(23, 4), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'unlock', 'details' : {}},
    ],

    'approaching_airport' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(16, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_AIRPORT_NEAR_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_AIRPORT_NEAR_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'capturing_airport' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(16, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_AIRPORT_CAP_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(15, 13), 'unit' : 'heli', 'side' : 'red'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_AIRPORT_CAP_2', 'portrait' : 'heli_red', 'name' : 'ACTOR_PILOT', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'capturing_flank_tower' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'spawn', 'details' : {'where' : Vector2(9, 1), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(10, 1), 'unit' : 'tank', 'side' : 'red'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_FLANK', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'blocking_hq' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(1, 12), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_BLOCK_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'right'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_5_BLOCK_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},
    'approaching_airport' : {'type' : 'move', 'story' : 'approaching_airport', 'details' : { 'fields' : [Vector2(18, 11), Vector2(18, 12), Vector2(18, 13), Vector2(18, 14), Vector2(17, 12), Vector2(17, 13), Vector2(17, 14), Vector2(16, 12), Vector2(16, 14), Vector2(15, 11), Vector2(15, 12), Vector2(15, 13), Vector2(15, 14)], 'player' : 1 }, 'one_off' : true},
    'capturing_airport' : {'type' : 'domination', 'story' : 'capturing_airport', 'details' : { 'amount' : 1, 'list' : [Vector2(16, 13)], 'player' : 1 }, 'one_off' : true},
    'capturing_flank_tower' : {'type' : 'domination', 'story' : 'capturing_flank_tower', 'details' : { 'amount' : 1, 'list' : [Vector2(7, 3)], 'player' : 1 }, 'one_off' : true},
    'blocking_hq' : {'type' : 'move', 'story' : 'blocking_hq', 'details' : { 'fields' : [Vector2(2, 12)], 'player' : 1 }, 'one_off' : true},
}
