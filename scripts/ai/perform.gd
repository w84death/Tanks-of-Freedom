extends "res://scripts/bag_aware.gd"

const INTERVAL = 0.15
const SKIP_INTERVAL = 1

func do_ai_stuff():
    if self.bag.controllers.action_controller.game_ended and self.bag.match_state.is_multiplayer:
        return

    if self.bag.root.is_paused || self.bag.camera.panning:
        self.bag.timers.set_timeout(self.SKIP_INTERVAL, self, "do_ai_stuff")
        return

    if self.bag.controllers.action_controller.perform_ai_stuff() != true:
        self.bag.controllers.action_controller.end_turn()
        return

    self.start_ai_timer()

func start_ai_timer():
    self.bag.timers.set_timeout(self.INTERVAL, self, "do_ai_stuff")
