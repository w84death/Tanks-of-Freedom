
var bag

func _init_bag(bag):
    self.bag = bag

func set_timeout(timeout, object, method, args=[]):
    var timer = Timer.new()
    timer.set_wait_time(timeout)
    timer.set_one_shot(true)
    timer.connect("timeout", self, "execute_timeout", [object, method, args, timer])
    self.bag.root.add_child(timer)
    timer.start()

func execute_timeout(object, method, args, timer):
    self.bag.root.remove_child(timer)
    timer.queue_free()
    if args.size() > 0:
        object.call(method, args)
    else:
        object.call(method)
