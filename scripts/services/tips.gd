const TIP_PREFIX = 'TIP_'
const TIP_COUNT = 13

var tip_counter

func _init():
    self.tip_counter = int(1)

func next_tip():
    self.tip_counter = self.tip_counter % self.TIP_COUNT + 1
    return tr(self.TIP_PREFIX + str(self.tip_counter))

func header():
    return tr(self.TIP_PREFIX + 'HEADER')
