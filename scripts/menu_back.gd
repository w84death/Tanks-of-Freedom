extends "res://scripts/bag_aware.gd"

func perform_back():
	# in campaign menu
	if self.bag.controllers.campaign_menu_controller.campaign_menu.is_visible():
		self.bag.controllers.campaign_menu_controller._back_button_pressed()
		return true

	# settings open
	if self.bag.controllers.menu_controller.get_settings_visibility():
		self.bag.controllers.menu_controller.toggle_settings()
		return true

	# viewing gamepad info
	if self.bag.gamepad_popup.popup.is_visible():
		self.bag.gamepad_popup._close_button_pressed()
		return true

	# selecting skirmish map
	if self.bag.controllers.menu_controller.maps_close_button.is_visible() and self.bag.map_picker.picker.is_visible():
		self.bag.controllers.menu_controller._maps_close_button_pressed()
		return true

	# skirmish/workshop game settings
	if self.bag.skirmish_setup.panel.is_visible():
		self.bag.skirmish_setup._back_button_pressed()
		return true

	# online menu visible
	if self.bag.controllers.online_menu_controller.back_button.is_visible():
		self.bag.controllers.online_menu_controller._back_button_pressed()
		return true

	# confirm popup
	if self.bag.confirm_popup.popup.is_visible():
		self.bag.confirm_popup._cancel_button_pressed()
		return true

	# prompt popup
	if self.bag.prompt_popup.popup.is_visible():
		self.bag.prompt_popup._cancel_button_pressed()
		return true

	# menu message popup
	if self.bag.message_popup.popup.is_visible() and self.bag.message_popup.confirm_button.is_visible():
		self.bag.message_popup._confirm_button_pressed()
		return true

	# menu big message popup
	if self.bag.message_big_popup.popup.is_visible() and self.bag.message_big_popup.confirm_button.is_visible():
		self.bag.message_big_popup._confirm_button_pressed()
		return true

	# in-game tooltip
	if self.bag.root.is_map_loaded and not self.bag.root.is_paused and self.bag.root.hud != null and self.bag.root.hud_controller.hud_message_card.is_visible():
		self.bag.root.hud_controller._hud_message_card_button_pressed()
		return true


	if self.bag.workshop.is_visible() and self.bag.workshop.is_working and not self.bag.workshop.is_suspended:
		# workshop map picker
		if self.bag.map_picker.picker.is_visible():
			self.bag.controllers.workshop_gui_controller.file_panel.pick_button_pressed()
			return true

		# workshop panel extended
		if self.bag.controllers.workshop_gui_controller.file_panel.is_extended():
			self.bag.controllers.workshop_gui_controller.file_panel._toggle_button_pressed()
			return true

		# workshop blocks picker
		if self.bag.controllers.workshop_gui_controller.building_blocks_panel.building_block_panel_wrapper.is_visible():
			self.bag.controllers.workshop_gui_controller.building_blocks_panel.building_block_panel_wrapper.hide()
			self.bag.controllers.workshop_gui_controller.navigation_panel.block_button.grab_focus()
			return true

		# workshop toolbox
		if self.bag.controllers.workshop_gui_controller.toolbox_panel.toolbox_panel_wrapper.is_visible():
			self.bag.controllers.workshop_gui_controller.hide_toolbox_panel()
			self.bag.controllers.workshop_gui_controller.navigation_panel.toolbox_button.grab_focus()
			return true


	return false

