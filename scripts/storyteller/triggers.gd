extends "res://scripts/bag_aware.gd"

var action_triggers = {
    'turn' : preload("res://scripts/storyteller/triggers/turn.gd").new(),
    'turn_end' : preload("res://scripts/storyteller/triggers/turn_end.gd").new(),
    'move' : preload("res://scripts/storyteller/triggers/move.gd").new(),
    'deploy' : preload("res://scripts/storyteller/triggers/deploy.gd").new(),
}


var current_triggers = {}



func _initialize():
    self.init_triggers()

func init_triggers():
    for trigger_name in self.action_triggers:
        self.action_triggers[trigger_name]._init_bag(self.bag)

func reset():
    self.current_triggers = {}


func load_map_triggers(map_data):
    self.current_triggers = map_data['triggers']

func mark_actors():
    var trigger
    var trigger_definition

    for trigger_name in self.current_triggers:
        trigger_definition = self.current_triggers[trigger_name]
        trigger = self.action_triggers[trigger_definition['type']]

        trigger.mark_actors(trigger_definition)


func feed_story_event(story_event):
    var trigger
    var trigger_definition
    for trigger_name in self.current_triggers:
        trigger_definition = self.current_triggers[trigger_name]
        trigger = self.action_triggers[trigger_definition['type']]
        if trigger.uses(story_event['type']) and trigger.is_triggered(trigger_definition, story_event):
            if trigger_definition.has('one_off') and trigger_definition['one_off'] and trigger_definition.has('triggered'):
                break
            self.bag.storyteller.tell_a_story(trigger_definition['story'])
            self.current_triggers[trigger_name]['triggered'] = true
            break
