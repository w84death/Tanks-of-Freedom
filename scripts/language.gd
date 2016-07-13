
var bag

var language_cycle = {
    'en' : 'pl',
    'pl' : 'fr',
    'fr' : 'en'
}

func _init_bag(bag):
    self.bag = bag

func switch_to_next_language():
    var old_language = self.bag.root.settings['language']
    var new_language = self.language_cycle[old_language]

    self.bag.root.settings['language'] = new_language
    TranslationServer.set_locale(new_language)
    self.bag.root.write_settings_to_file()

    self.reload_labels()


func reload_labels():
    #MAIN MENU BUTTONS
    var menu = self.bag.controllers.menu_controller
    menu.manage_close_button()
    self.reload_button(menu.demo_button, 'LABEL_RUN_DEMO', 'Label1')
    self.reload_button(menu.settings_button, 'LABEL_SETTINGS')
    self.reload_button(menu.quit_button, 'LABEL_QUIT_GAME')
    self.reload_button(menu.campaign_button, 'LABEL_CAMPAIGN')
    self.reload_button(menu.play_button, 'LABEL_SKIRMISH')
    self.reload_button(menu.online_button, 'LABEL_ONLINE')
    self.reload_button(menu.workshop_button, 'LABEL_MAP EDITOR')

    #SETTINGS LABELS AND BUTTONS
    var settings = menu.settings
    if settings:
        self.reload_label(settings.get_node('effects1'), 'LABEL_DIFFICULTY')
        self.reload_label(settings.get_node('auto_follow_'), 'LABEL_AUTO_FOLLOW')
        self.reload_label(settings.get_node('shake'), 'LABEL_CAMERA_SHAKE')
        self.reload_label(settings.get_node('display_mode_'), 'LABEL_FULL_SCREEN')
        self.reload_label(settings.get_node('language_group/language_label'), 'LABEL_LANGUAGE')
        self.reload_label(settings.get_node('zoom_level_'), 'LABEL_ZOOM_LEVEL')
        self.reload_button(menu.camera_zoom_in_button, 'LABEL_BIGGER')
        self.reload_button(menu.camera_zoom_out_button, 'LABEL_SMALLER')
        self.reload_label(settings.get_node('effects'), 'LABEL_SOUND_EFFECTS')
        self.reload_label(settings.get_node('music'), 'LABEL_MUSIC')
        self.reload_label(settings.get_node('overscan_group/overscan_label'), 'LABEL_OVERSCAN')
        self.reload_label(settings.get_node('overscan_group/overscan_notification'), 'LABEL_REQUIES_RESTART')


func reload_button(button, translation, label_node_name="Label"):
    if button:
        button.get_node(label_node_name).set_text(tr(translation))

func reload_label(label, translation):
    if label:
        label.set_text(tr(translation))
