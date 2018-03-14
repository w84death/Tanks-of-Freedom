extends "res://scripts/ai/actions/handlers/unit_handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    print("attack")
    .execute(action)

func __on_success(action):
    self.bag.positions.refresh_units()
    var field = self.__get_next_tile_from_path(action.path)
    if field.object == null or field.object.life == 0:
        # if unit killed all action connected to him will be invalidated
        self.remove_for_destination(action)

    self.set_zero_score(action)

    if action.unit.life > 0 && self.get_actions_for_unit(action.unit).size() == 0:
        self.mark_unit_for_calculations(action.unit)

    self.reset_current_action()
