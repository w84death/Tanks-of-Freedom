var root_node
var bag
var shown_units = []
var unit_list = []
var last_direction = null
var counter = 0

const NEXT = 0;
const BACK = 1;

func init_root(root):
    self.root_node = root
    self.bag = self.root_node.bag

func switch_unit(player, active_field, direction=self.NEXT):
    self.bag.positions.refresh_units()
    var units = self.bag.positions.get_player_units(player)
    
    self.__create_unit_list(units)

    if active_field == null:                                          
        self.counter = 0
        return self.unit_list[self.counter]

    var pos = self.__get_unit_position(direction)
    if (pos == active_field.object.get_pos_map()) :
        pos = self.__get_unit_position(direction)

    return pos

func __get_unit_position(direction):
    if direction == self.NEXT:
        self.counter = self.counter + 1
    else:
        self.counter = self.counter - 1

    self.counter = self.counter % unit_list.size()

    # TODO repair for modulo
    if (self.counter < 0):
        self.counter = self.unit_list.size() - abs(self.counter)

    return self.unit_list[self.counter]

func __create_unit_list(units):
    self.unit_list.clear()
    for pos in units:
        self.unit_list.append(units[pos].get_pos_map())
