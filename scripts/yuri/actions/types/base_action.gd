
var score_cap = 0

var score = 0

func set_score(score):
    if self.score_cap > 0 and self.score_cap < score:
        self.score = self.score_cap
    else:
        self.score = score