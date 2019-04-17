extends "res://scripts/bag_aware.gd"

const STEP_INTERVAL = 0.2

var action_triggers = preload("res://scripts/storyteller/triggers.gd").new()

var action_handlers = {
	'lock' : preload("res://scripts/storyteller/actions/lock_hud.gd").new(),
	'unlock' : preload("res://scripts/storyteller/actions/unlock_hud.gd").new(),
	'camera' : preload("res://scripts/storyteller/actions/camera.gd").new(),
	'sleep' : preload("res://scripts/storyteller/actions/sleep.gd").new(),
	'move' : preload("res://scripts/storyteller/actions/move.gd").new(),
	'die' : preload("res://scripts/storyteller/actions/die.gd").new(),
	'claim' : preload("res://scripts/storyteller/actions/claim.gd").new(),
	'win' : preload("res://scripts/storyteller/actions/win.gd").new(),
	'message' : preload("res://scripts/storyteller/actions/message.gd").new(),
	'terrain_add' : preload("res://scripts/storyteller/actions/terrain_add.gd").new(),
	'terrain_remove' : preload("res://scripts/storyteller/actions/terrain_remove.gd").new(),
	'terrain_damage' : preload("res://scripts/storyteller/actions/terrain_damage.gd").new(),
	'spawn' : preload("res://scripts/storyteller/actions/spawn.gd").new(),
	'attack' : preload("res://scripts/storyteller/actions/attack.gd").new(),
	'despawn' : preload("res://scripts/storyteller/actions/despawn.gd").new(),
	'trigger' : preload("res://scripts/storyteller/actions/trigger.gd").new(),
}

var available_stories = {}

var current_story = []
var story_bookmark = 0
var pause = false
var camera_zoom_level = null

func _initialize():
	self.action_triggers._init_bag(self.bag)
	self.init_handlers()
	self.camera_zoom_level = self.bag.root.settings['camera_zoom']

func reset():
	self.story_bookmark = 0
	self.current_story = []
	self.pause = false

func clear_stories():
	self.reset()
	self.available_stories = {}
	self.action_triggers.reset()

func init_handlers():
	for handler_name in self.action_handlers:
		self.action_handlers[handler_name]._init_bag(self.bag)

func load_map_story(map_data):
	self.clear_stories()
	self.available_stories = map_data['stories']
	self.action_triggers.load_map_triggers(map_data)

func mark_actors():
	self.action_triggers.mark_actors()

func load_story(story_name):
	self.reset()
	self.current_story = self.available_stories[story_name]

func tell_a_story(story_name):
	self.load_story(story_name)
	self.bag.camera.stop()
	self.perform_next_action()


func perform_next_action():
	if self.story_bookmark == self.current_story.size():
		if self._has_map_modifications():
			self.bag.ai.pathfinder.rebuild_current_grid()
			self.bag.ai.reset()
			self.bag.root.current_map.connect_fences()

		if self._has_unit_modifications():
			self.bag.ai.reset()
			self.bag.fog_controller.clear_fog()

		return

	if self.pause or self.bag.camera.panning or self.bag.root.is_paused:
		self.bag.timers.set_timeout(self.STEP_INTERVAL, self, "perform_next_action")
		return

	var story_step = self.current_story[self.story_bookmark]

	self.action_handlers[story_step['action']].perform(story_step['details'])

	self.story_bookmark = self.story_bookmark + 1

	if story_step.has('delay'):
		self.bag.timers.set_timeout(story_step['delay'], self, "perform_next_action")
	else:
		self.bag.timers.set_timeout(self.STEP_INTERVAL, self, "perform_next_action")

func register_story_event(story_event):
	self.action_triggers.feed_story_event(story_event)

func _has_map_modifications():
	for step in self.current_story:
		if step['action'] == 'terrain_add' or step['action'] == 'terrain_remove':
			return true

	return false

func _has_unit_modifications():
	for step in self.current_story:
		if step['action'] == 'die' or step['action'] == 'despawn' or step['action'] == 'spawn':
			return true

	return false

