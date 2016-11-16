extends "res://scripts/bag_aware.gd"

func execute():
    print('executing script')
    self.click(Vector2(14,20), 0.5)
    self.click(Vector2(13,20), 0.5)
    self.move_camera(Vector2(1,1), 2)


func click(position, delay):
    self.bag.timers.set_timeout(delay, self, "__click", [position])

func move_camera(position, delay):
    self.bag.timers.set_timeout(delay, self, "__move_camera", [position])

func __click(args):
    self.bag.controllers.action_controller.handle_action(args[0])

func __move_camera(args):
    self.bag.controllers.action_controller.move_camera_to_point(args[0])