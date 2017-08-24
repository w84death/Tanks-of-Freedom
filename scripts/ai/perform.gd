extends "res://scripts/bag_aware.gd"

const INTERVAL = 0.15
const SKIP_INTERVAL = 1
var running = false
var pause = false

func do_ai_stuff():
    if !self.running:
        return

    if self.bag.controllers.action_controller.game_ended and self.bag.match_state.is_multiplayer:
        self.stop_ai_timer()
        return

    if self.bag.root.is_paused || self.bag.camera.panning || self.pause:
        self.__execute_with_interval(self.SKIP_INTERVAL)
        return

    if self.bag.controllers.action_controller.perform_ai_stuff() != true:
        self.bag.controllers.action_controller.end_turn()
        return

    self.__execute_with_interval(self.INTERVAL)

func start_ai_timer():
    self.running = true
    self.__execute_with_interval(self.INTERVAL)

func stop_ai_timer():
    self.running = false

func __execute_with_interval(interval):
    self.bag.timers.set_timeout(interval, self, "do_ai_stuff")