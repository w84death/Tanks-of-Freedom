extends "res://scripts/storyteller/triggers/abstract_trigger.gd"

func _initialize():
    self.trigger_types_used['move'] = true

func is_triggered(trigger_details, story_event):
    for field in trigger_details['details']['fields']:
        if field == story_event['details']['where']:
            if trigger_details['details'].has('player'):
                if trigger_details['details']['player'] == story_event['details']['who'].player:
                    return true
            else:
                return true

    return false
