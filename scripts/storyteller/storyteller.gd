
var bag

const STEP_INTERVAL = 0.2

var action_handlers = {}

var current_story = []
var story_bookmark = 0
var pause = false

func _init_bag(bag):
    self.bag = bag
    self.init_handlers()

func init_handlers():
    for handler_name in self.action_handlers:
        self.action_handlers._init_bag(self.bag)


func load_story():
    self.story_bookmark = 0
    self.pause = false

func tell_a_story():
    self.load_story()
    self.perform_next_action()


func perform_next_action():
    if self.story_bookmark == self.current_story.size():
        return

    if self.pause:
        self.bag.timers.set_timeout(self.STEP_INTERVAL, self, "perform_next_action")
        return


    self.story_bookmark = self.story_bookmark + 1
    self.bag.timers.set_timeout(self.STEP_INTERVAL, self, "perform_next_action")
