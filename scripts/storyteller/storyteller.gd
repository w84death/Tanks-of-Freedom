
var bag

const STEP_INTERVAL = 0.2

var action_handlers = {
    'lock' : preload("res://scripts/storyteller/actions/lock_hud.gd").new(),
    'camera' : preload("res://scripts/storyteller/actions/camera.gd").new(),
    'sleep' : preload("res://scripts/storyteller/actions/sleep.gd").new(),
    'move' : preload("res://scripts/storyteller/actions/move.gd").new(),
    'die' : preload("res://scripts/storyteller/actions/die.gd").new(),
}

var current_story = []
var story_bookmark = 0
var pause = false

func _init_bag(bag):
    self.bag = bag
    self.init_handlers()

func init_handlers():
    for handler_name in self.action_handlers:
        self.action_handlers[handler_name]._init_bag(self.bag)


func load_story():
    self.story_bookmark = 0
    self.pause = false
    self.ugly_hardcoded_story()

func tell_a_story():
    self.load_story()
    self.perform_next_action()


func perform_next_action():
    if self.story_bookmark == self.current_story.size():
        return

    if self.pause or self.bag.camera.panning:
        self.bag.timers.set_timeout(self.STEP_INTERVAL, self, "perform_next_action")
        return

    var story_step = self.current_story[self.story_bookmark]

    self.action_handlers[story_step['action']].perform(story_step['details'])

    self.story_bookmark = self.story_bookmark + 1

    if story_step.has('delay'):
        self.bag.timers.set_timeout(story_step['delay'], self, "perform_next_action")
    else:
        self.bag.timers.set_timeout(self.STEP_INTERVAL, self, "perform_next_action")




func ugly_hardcoded_story():
    if self.bag.root.workshop_file_name == false:
        self.current_story = []
        return

    if self.bag.root.workshop_file_name == "PDMPD4MX":
        self.current_story = [
            {'action' : 'lock', 'details' : {}, 'delay': 1},
            {'action' : 'camera', 'details' : {'where' : Vector2(30, 19), 'speed' : 1}},
            {'action' : 'move', 'details' : {'who' : Vector2(28, 21), 'where' : Vector2(28, 20)}},
            {'action' : 'move', 'details' : {'who' : Vector2(30, 21), 'where' : Vector2(30, 20)}},
            {'action' : 'move', 'details' : {'who' : Vector2(28, 20), 'where' : Vector2(28, 19)}},
            {'action' : 'move', 'details' : {'who' : Vector2(30, 20), 'where' : Vector2(30, 19)}},
            {'action' : 'move', 'details' : {'who' : Vector2(28, 19), 'where' : Vector2(27, 19)}},
            {'action' : 'move', 'details' : {'who' : Vector2(30, 19), 'where' : Vector2(29, 19)}},
            {'action' : 'move', 'details' : {'who' : Vector2(27, 19), 'where' : Vector2(27, 18)}},
            {'action' : 'move', 'details' : {'who' : Vector2(29, 19), 'where' : Vector2(29, 18)}},
            {'action' : 'die', 'details' : {'who' : Vector2(27, 17)}},
            {'action' : 'die', 'details' : {'who' : Vector2(28, 17)}},
            {'action' : 'die', 'details' : {'who' : Vector2(26, 17)}},
            {'action' : 'die', 'details' : {'who' : Vector2(30, 17)}},
            {'action' : 'die', 'details' : {'who' : Vector2(29, 17)}},
            {'action' : 'sleep', 'details' : {'time' : 2}},
            {'action' : 'camera', 'details' : {'where' : Vector2(25, 19)}},
        ]
    else:
        self.current_story = []