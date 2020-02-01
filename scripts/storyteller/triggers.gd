extends "res://scripts/bag_aware.gd"

var action_triggers = {
	'turn' : preload("res://scripts/storyteller/triggers/turn.gd").new(),
	'turn_end' : preload("res://scripts/storyteller/triggers/turn_end.gd").new(),
	'move' : preload("res://scripts/storyteller/triggers/move.gd").new(),
	'deploy' : preload("res://scripts/storyteller/triggers/deploy.gd").new(),
	'domination' : preload("res://scripts/storyteller/triggers/domination.gd").new(),
	'assasination' : preload("res://scripts/storyteller/triggers/assasination.gd").new(),
}


var current_triggers = {}

var triggered_triggers = {}


func _initialize():
	self.init_triggers()

func init_triggers():
	for trigger_name in self.action_triggers:
		self.action_triggers[trigger_name]._init_bag(self.bag)

func reset():
	self.current_triggers = {}
	self.triggered_triggers = {}


func load_map_triggers(map_data):
	self.reset()
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
		if trigger_definition.has('suspended') and trigger_definition['suspended']:
			continue

		if trigger.uses(story_event['type']) and trigger.is_triggered(trigger_definition, story_event):
			if trigger_definition.has('one_off') and trigger_definition['one_off'] and self.triggered_triggers.has(trigger_name):
				continue
			self.bag.storyteller.tell_a_story(trigger_definition['story'])
			self.triggered_triggers[trigger_name] = trigger_name
			break

func suspend(trigger_name, is_suspended=true):
	self.current_triggers[trigger_name]['suspended'] = is_suspended
