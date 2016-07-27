
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
    #MAIN MENU
    var menu = self.bag.controllers.menu_controller
    menu.manage_close_button()
    self.reload_button(menu.demo_button, 'LABEL_RUN_DEMO', 'Label1')
    self.reload_button(menu.settings_button, 'LABEL_SETTINGS')
    self.reload_button(menu.quit_button, 'LABEL_QUIT_GAME')
    self.reload_button(menu.campaign_button, 'LABEL_CAMPAIGN')
    self.reload_button(menu.play_button, 'LABEL_SKIRMISH')
    self.reload_button(menu.online_button, 'LABEL_ONLINE')
    self.reload_button(menu.workshop_button, 'LABEL_MAP EDITOR')

    #SETTINGS
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

    #CAMPAIGN
    var campaign = self.bag.controllers.campaign_menu_controller
    if campaign:
        self.reload_button(campaign.back_button, 'LABEL_BACK')
        self.reload_button(campaign.prev_button, 'LABEL_PREVIOUS', 'title')
        self.reload_button(campaign.next_button, 'LABEL_NEXT', 'title')
        self.reload_button(campaign.start_button, 'LABEL_START', 'title')
        self.reload_label(campaign.campaign_menu.get_node('middle/control/dialog_controls/playing_as'), 'LABEL_PLAYING_AS')
        self.reload_label(campaign.campaign_menu.get_node('middle/control/dialog_controls/difficulty_'), 'LABEL_DIFFICULTY')
        self.reload_label(campaign.campaign_menu.get_node('middle/control/dialog_controls/red/blue_team'), 'LABEL_RED_TEAM')
        self.reload_label(campaign.campaign_menu.get_node('middle/control/dialog_controls/blue/blue_team'), 'LABEL_BLUE_TEAM')
        self.reload_label(campaign.campaign_menu.get_node('middle/control/dialog_controls/mission_num_'), 'LABEL_MISSION')

    #SKIRMISH
    var skirmish = menu.maps_sub_menu
    self.reload_button(skirmish.get_node("bottom/control/menu_controls/close"), 'LABEL_BACK')
    self.reload_button(self.bag.map_picker.delete_button, 'LABEL_DELETE_MODE')
    self.reload_label(self.bag.map_picker.picker.get_node('controls/maps_label'), 'LABEL_MAPS')
    self.reload_label(self.bag.map_picker.picker.get_node('controls/page_label'), 'LABEL_PAGE')

    self.reload_button(self.bag.skirmish_setup.back_button, 'LABEL_BACK')
    self.reload_button(self.bag.skirmish_setup.play_button, 'LABEL_PLAY')
    self.reload_label(self.bag.skirmish_setup.panel.get_node('controls/selected_map_'), 'LABEL_SELECTED_MAP')
    self.reload_label(self.bag.skirmish_setup.panel.get_node('controls/maps_page'), 'LABEL_TURNS_CAP')


func reload_button(button, translation, label_node_name="Label"):
    if button:
        button.get_node(label_node_name).set_text(tr(translation))

func reload_label(label, translation):
    if label:
        label.set_text(tr(translation))
