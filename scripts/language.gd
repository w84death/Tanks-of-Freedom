
var bag

var language_cycle = {
    'en' : 'pl',
    'pl' : 'en'
}

func _init_bag(bag):
    self.bag = bag

func switch_to_next_language():
    var old_language = self.bag.root.settings['language']
    var new_language = self.language_cycle[old_language]

    self.bag.root.settings['language'] = new_language
    self.bag.root.write_settings_to_file()