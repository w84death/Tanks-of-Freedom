var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 11), 'zoom' : 1}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_INTRO', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(9, 4), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_OBJECTIVE', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(6, 11), 'zoom' : 1}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_TOWER_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(6, 4), 'zoom' : 1}, 'delay' : 0.5},
        {'action' : 'claim', 'details' : {'what' : Vector2(6, 4), 'side' : 1}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_TOWER_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(9, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'move', 'details' : {'who' : Vector2(9, 7), 'where' : Vector2(9, 6)}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_SOLDIER_SHOUT', 'portrait' : 'soldier_blue', 'name' : 'ACTOR_FREEDOM_FIGHTER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_ORDER', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'move', 'details' : {'who' : Vector2(8, 4), 'where' : Vector2(8, 5)}},
        {'action' : 'move', 'details' : {'who' : Vector2(9, 4), 'where' : Vector2(9, 5)}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_GUARD', 'portrait' : 'soldier_red', 'name' : 'ACTOR_PALACE_GUARD', 'side' : 'right'}},
        {'action' : 'attack', 'details' : {'who' : Vector2(9, 5), 'whom' : Vector2(9, 6)}, 'delay' : 1},
        {'action' : 'die', 'details' : {'who' : Vector2(9, 6)}, 'delay' : 2},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_COMMAND', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'objective_nearby' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(9, 4), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_NEARBY', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'hq_in_danger' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 11), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_DEFEND', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ],

    'loosing_soldiers' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 1},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 11), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_1_OFFICER_DEPLOY', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'unlock', 'details' : {}},
    ]
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},
    'objective_nearby' : {'type' : 'move', 'story' : 'objective_nearby', 'details' : { 'fields' : [Vector2(7, 3), Vector2(8, 3), Vector2(10, 3), Vector2(7, 4), Vector2(8, 4), Vector2(9, 4), Vector2(10, 4), Vector2(7, 5), Vector2(8, 5), Vector2(9, 5), Vector2(10, 5)], 'player' : 0 }, 'one_off' : true},
    'hq_in_danger' : {'type' : 'move', 'story' : 'hq_in_danger', 'details' : { 'fields' : [Vector2(7, 9), Vector2(8, 9), Vector2(9, 9), Vector2(10, 9), Vector2(7, 10), Vector2(8, 10), Vector2(9, 10), Vector2(10, 10), Vector2(7, 11), Vector2(9, 11), Vector2(10, 11)], 'player' : 1 }, 'one_off' : true},
    'loosing_soldiers' : {'type' : 'deploy', 'story' : 'loosing_soldiers', 'details' : { 'amount' : 3, 'player' : 0, 'exact' : true }, 'one_off' : true},
}
