
var bag
var wrapper_template = preload("res://scripts/processing_wrapper.gd")

var ready = false

var objects = {}

func _init_bag(bag):
    self.bag = bag
    self.ready = true

func register(object):
    var wrapper = self.wrapper_template.new(self, object)
    self.objects[object.get_instance_ID()] = wrapper
    self.bag.root.add_child(wrapper)

func remove(object):
    var wrapper = self.objects[object.get_instance_ID()]
    wrapper.kill()
    self.bag.root.remove_child(wrapper)
    self.objects.erase(wrapper)

func reset():
    for id in self.objects:
        self.remove(self.objects[id])
