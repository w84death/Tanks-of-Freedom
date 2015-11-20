
extends Control

var processing

var handler
var working = true

func _init(processing, handler):
    self.processing = processing
    self.handler = handler
    self.set_fixed_process(true)

func kill():
    self.working = false
    self.processing = null
    self.handler = null
    self.queue_free()

func _fixed_process(delta):
    if not self.working || not self.processing.ready:
        return

    self.handler.process(delta)
