const DOMINATION    = "domination"
const MOVES         = "moves"
const TOTAL_TIME    = "total_time"
const KILLS         = "kills"
const TIME          = "time"
const SPAWNS        = "spawns"
const SCORE         = "score"
const TIME_FORMATED = "time_formated"

var stats = {
    self.DOMINATION    : [0, 0],
    self.MOVES         : [0, 0],
    self.KILLS         : [0, 0],
    self.TIME          : [0, 0],
    self.SPAWNS        : [0, 0],
    self.SCORE         : [0, 0],
    self.TOTAL_TIME    : 1,
    self.TIME_FORMATED : ['0:00', '0:00'],
}

var start_time

func add_domination(player, value):
    self.__increment(self.DOMINATION, player, value)

func add_spawn(player):
    self.__increment(self.SPAWNS, player)

func add_kills(player):
    self.__increment(self.KILLS, player)

func add_moves(player):
    self.__increment(self.MOVES, player)

func start_counting_time():
    start_time = OS.get_unix_time()

func set_counting_time(player):
    var time_now = OS.get_unix_time()

    self.__increment(self.TIME, player, time_now - start_time)
    start_time = time_now

func get_stats():
    self.__calculate_score()

    self.stats[self.TOTAL_TIME] = __time_format(self.stats[self.TIME][0] + self.stats[self.TIME][1])
    self.stats[self.TIME_FORMATED] = [__time_format(self.stats[self.TIME][0]), __time_format(self.stats[self.TIME][1])]

    return self.stats;

func __calculate_score():
    self.stats[self.SCORE][0] = (self.stats[self.DOMINATION][0] * 3 + self.stats[self.KILLS][0] * 2 + self.stats[self.MOVES][0] + self.stats[self.SPAWNS][0]) * 10
    self.stats[self.SCORE][1] = (self.stats[self.DOMINATION][1] * 3 + self.stats[self.KILLS][1] * 2 + self.stats[self.MOVES][1] + self.stats[self.SPAWNS][1]) * 10

func __time_format(value):
    var m = floor(value / 60)
    var s = value - m * 60

    return self.__fill(str(m))+ ':' + self.__fill(str(s))

func __fill(value):
    if value.length() < 2:
        value = '0'+value

    return value

func __increment(stat, player, value = 1):
    self.stats[stat][player] = self.stats[stat][player] + value

