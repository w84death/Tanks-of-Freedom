extends "res://scripts/ai/actions/handlers/unit_handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    print("capture")
    .execute(action)

func __on_success(action):
    self.remove_for_destination(action)
    self.remove_for_waypointed_building(action)

    self.bag.positions.refresh_units()
    self.bag.positions.refresh_buildings()
    self.bag.waypoint_factory.update_waypoints() # TODO we can update only one waypoint here

    if action.destination.type != 4: #if gsm tower
        self.remove_for_unit(action.unit)
        self.mark_unit_for_calculations(action.unit)
        self.remove_for_position(action.unit.player, action.unit.position_on_map)

    self.reset_current_action()

