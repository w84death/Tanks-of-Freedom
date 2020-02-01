extends "res://scripts/bag_aware.gd"

func execute():
	print('executing script')
	self.click(Vector2(14,20), 0.5)
	self.click(Vector2(13,20), 0.5)
	self.move_camera(Vector2(1,1), 2)


func click(positionVAR, delay):
	self.bag.timers.set_timeout(delay, self, "__click", [positionVAR])

func move_camera(positionVAR, delay):
	self.bag.timers.set_timeout(delay, self, "__move_camera", [positionVAR])

func __click(args):
	self.bag.controllers.action_controller.handle_action(args[0])

func __move_camera(args):
	self.bag.controllers.action_controller.move_camera_to_point(args[0])