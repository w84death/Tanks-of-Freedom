
var entity

var score_cap = 0

var score = 0

func _init(entity):
    self.entity = entity

func set_score(score):
    if self.score_cap > 0 and self.score_cap < score:
        self.score = self.score_cap
    else:
        self.score = score