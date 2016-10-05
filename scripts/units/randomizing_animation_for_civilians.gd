func _ready():
    randomize()
    get_node("anim").seek(randf())
    if randf() < 0.5:
        self.set_flip_h(true)

    get_node("anim").set_speed(rand_range(0.5, 1.5))
