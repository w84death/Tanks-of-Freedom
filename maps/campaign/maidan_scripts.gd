var stories = {
    'tower_tip' : [
        {'action' : 'lock', 'details' : {}, 'delay' : 2},
        {'action' : 'camera', 'details' : {'where' : Vector2(6, 11), 'zoom' : 1}, 'delay' : 2},
        #{'action' : 'message', 'details': {'text' : 'CAMPAIGN_MISSION_1_TOWER_TIP', 'portrait' : 'soldier_blue'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(9, 3), 'zoom' : 1}, 'delay' : 2},
        #{'action' : 'message', 'details': {'text' : 'CAMPAIGN_MISSION_1_ENEMY_HQ', 'portrait' : 'soldier_blue'}},
        {'action' : 'camera', 'details' : {'where' : Vector2(8, 12), 'zoom' : 3}, 'delay' : 2},
        {'action' : 'unlock', 'details' : {}},

        #{'action' : 'move', 'details' : {'who' : Vector2(12, 10), 'where' : Vector2(13, 10)}},
        #{'action' : 'die', 'details' : {'who' : Vector2(18, 19)}, 'delay' : 2},
        #{'action' : 'claim', 'details' : {'what' : Vector2(19, 14), 'side' : 0}},
    ]
}

var triggers = {
    'first_turn' : {'type' : 'turn', 'story' : 'tower_tip', 'details' : { 'turn' : 1 }}
}
