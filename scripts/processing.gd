extends "res://scripts/bag_aware.gd"

var wrapper_template = load("res://scripts/processing_wrapper.gd")

var ready = false

var objects = {}

func _initialize():
	self.ready = true

func register(object):
	var wrapper = self.wrapper_template.new(self, object)
	self.objects[object.get_instance_id()] = wrapper
	self.bag.root.add_child(wrapper)

func remove_and_collide(object):
	var wrapper = self.objects[object.get_instance_id()]
	wrapper.kill()
	self.bag.root.remove_child(wrapper)
	self.objects.erase(wrapper)

func reset():
	for object in self.objects.values():
		self.remove_and_collide(object)

