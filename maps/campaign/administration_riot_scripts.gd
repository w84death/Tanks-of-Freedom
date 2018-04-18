var stories = {
    'introduction' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(15, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_OFFICER_INTRO_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_OFFICER_INTRO_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(4, 3), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_OBJECTIVE', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(14, 6), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_TANK_1', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'left'}},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_TANK_2', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_TANK_FACTORY', 'portrait' : 'officer_red', 'name' : 'ACTOR_MILITIA_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(15, 3), 'zoom' : 2}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'factory_claimed' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_OFFICER_FACTORY_CAP_1', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'spawn', 'details' : {'where' : Vector2(8, 13), 'unit' : 'tank', 'side' : 'red'}, 'delay' : 1},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_OFFICER_FACTORY_CAP_2', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}},
        {'action' : 'unlock', 'details' : {}},
    ],
    'factory_claimed_ai' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 0.5},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}, 'delay' : 0.5},
        {'action' : 'message', 'details': {'text' : 'MISSION_3_OFFICER_FACTORY_AI', 'portrait' : 'officer_blue', 'name' : 'ACTOR_OFFICER', 'side' : 'left'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(7, 13), 'zoom' : 2}},
        {'action' : 'unlock', 'details' : {}},
    ],
}

var triggers = {
    'introduction' : {'type' : 'turn', 'story' : 'introduction', 'details' : { 'turn' : 1 }, 'one_off' : true},
    'factory_claimed' : {'type' : 'domination', 'story' : 'factory_claimed', 'details' : { 'amount' : 1, 'list' : [Vector2(7, 13)], 'player' : 1 }, 'one_off' : true},
    'factory_claimed_ai' : {'type' : 'domination', 'story' : 'factory_claimed_ai', 'details' : { 'amount' : 1, 'list' : [Vector2(7, 13)], 'player' : 0 }, 'one_off' : true},

}
