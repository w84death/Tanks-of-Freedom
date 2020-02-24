extends "res://scripts/storyteller/actions/abstract_action.gd"



func perform(action_details):
	var current_map = self.bag.root.current_map
	var type = action_details['type']
	var positionVAR = action_details['where']
	var frame = null

	if action_details.has('frame'):
		frame = action_details['frame']

	if type == 'forest':
		self.add_forest(positionVAR, frame)
	elif type == 'city_small':
		self.add_city_small(positionVAR, frame)
	elif type == 'city_big':
		self.add_city_big(positionVAR, frame)
	elif type == 'mountain':
		self.add_mountain(positionVAR, frame)
	elif type == 'wall':
		self.add_fence(positionVAR, frame)

	self.bag.root.sound_controller.play('spawn')



func add_forest(positionVAR, frame = null):
	self._add_non_movable(positionVAR, frame, randi()%10)

func add_city_small(positionVAR, frame = null):
	self._add_city_block(self.bag.root.current_map.map_city_small, positionVAR, frame)

func add_city_big(positionVAR, frame = null):
	self._add_city_block(self.bag.root.current_map.map_city_big, positionVAR, frame)

func add_mountain(positionVAR, frame = null):
	self._add_non_movable(positionVAR, frame, 11 + (randi()%2))

func add_fence(positionVAR, frame = null):
	var temp = self.bag.root.current_map.map_buildings[6].instance()
	self.bag.root.current_map.attach_object(positionVAR, temp)
	if frame != null:
		temp.set_frame(frame)
	self.bag.abstract_map.get_field(positionVAR).object = temp



func _add_non_movable(positionVAR, frame, random_frame):
	var temp = self.bag.root.current_map.map_non_movable.instance()
	if frame == null:
		temp.set_frame(random_frame)
	else:
		temp.set_frame(frame)

	self.bag.root.current_map.attach_object(positionVAR, temp)
	self.bag.abstract_map.get_field(positionVAR).object = temp

func _add_city_block(templates, positionVAR, frame):
	var temp

	if frame == null:
		temp = templates[randi() % templates.size()].instance()
	else:
		temp = templates[frame].instance()

	self.bag.root.current_map.attach_object(positionVAR, temp)
	self.bag.abstract_map.get_field(positionVAR).object = temp

