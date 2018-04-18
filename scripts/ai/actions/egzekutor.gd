extends "res://scripts/bag_aware.gd"

var hands = {
    "spawn" : preload("res://scripts/ai/actions/hands/spawn_hand.gd").new(),
    "move" : preload("res://scripts/ai/actions/hands/move_hand.gd").new(),
}


func _initialize():
    for hand_name in self.hands:
        self.hands[hand_name]._init_bag(self.bag)


func execute(action):
    var hand = self._get_hand(action)
    hand.execute(action)
    action.proceed()


func _get_hand(action):
    for hand_name in self.hands:
        if action extends self.hands[hand_name].handled_action:
            return self.hands[hand_name]
