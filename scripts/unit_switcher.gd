var root_node
var bag
var shown_units = []

func init_root(root):
    self.root_node = root
    self.bag = self.root_node.bag

func next_unit(player, active_field):
    self.bag.positions.refresh_units()
    var units = self.bag.positions.get_player_units(player)
    var unit
    if active_field == null:
        unit = units[units.keys()[0]]
        self.shown_units.append(unit.get_instance_ID())
        return unit

    if self.shown_units.size() >= units.size():
        self.shown_units.clear()

    for unit_pos in units:
        unit = units[unit_pos]
        if unit.ap > 0 && self.shown_units.find(unit.get_instance_ID()) == -1 && active_field.object != unit:
            self.shown_units.append(unit.get_instance_ID())
            return unit

func reset():
    self.shown_units.clear()
