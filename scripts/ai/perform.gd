extends "res://scripts/bag_aware.gd"

var running = false
var pause = false

var ai_speeds = [
    [0.5, 2],
    [0.3, 1.5],
    [0.15, 1],
    [0.08, 0.5],
    [0.05, 0.01]
]

var interval
var skip_interval

func _initialize():
    self.update_ai_speed()

func do_ai_stuff():
    if !self.running:
        return

    if self.bag.controllers.action_controller.game_ended and self.bag.match_state.is_multiplayer:
        self.stop_ai_timer()
        return

    if self.bag.root.is_paused || self.bag.camera.panning || self.pause || self.bag.controllers.action_controller.exploding:
        self.__execute_with_interval(self.skip_interval)
        return

    if self.bag.controllers.action_controller.perform_ai_stuff() != true:
        self.bag.controllers.action_controller.end_turn()
        return

    self.__execute_with_interval(self.interval)

func start_ai_timer():
    self.running = true
    self.pause = false
    self.__execute_with_interval(self.interval)

func stop_ai_timer():
    self.running = false

func __execute_with_interval(interval):
    self.bag.timers.set_timeout(interval, self, "do_ai_stuff")

func update_ai_speed():
    self.__set_ai_speed(self.bag.root.settings['ai_speed'])

func __set_ai_speed(speed):
    var intervals = self.ai_speeds[speed]
    self.interval = intervals[0]
    self.skip_interval = intervals[1]