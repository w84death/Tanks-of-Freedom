extends "res://scripts/storyteller/triggers/abstract_trigger.gd"

func _initialize():
    self.trigger_types_used['move'] = true

func mark_actors(trigger_details):
    var vip

    if trigger_details['details'].has('vip'):
        vip = trigger_details['details']['vip']
        self._mark_actor(vip, self._create_vip_mark(vip))


func is_triggered(trigger_details, story_event):
    var mark
    var has_vip = false
    var has_player = false
    var who = story_event['details']['who']

    if trigger_details['details'].has('vip'):
        has_vip = true
        mark = self._create_vip_mark(trigger_details['details']['vip'])

    if trigger_details['details'].has('player'):
        has_player = true

    for field in trigger_details['details']['fields']:
        if field == story_event['details']['where']:
            if has_vip:
                if who.story_markers.has(mark):
                    return true
            elif has_player:
                if trigger_details['details']['player'] == who.player:
                    return true
            elif not (has_player or has_vip):
                return true

    return false

func _create_vip_mark(vip):
    return "vip_" + str(vip.x) + "_" + str(vip.y)
