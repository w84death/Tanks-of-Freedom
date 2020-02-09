#!/bin/bash

find . -type f -name "*.gd" -exec sed -i 's/Globals.get/ProjectSettings.get_setting/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/display\//display\/window\/size\//g' {} +;


find . -type f -name "*resolution.gd" -exec sed -i 's/OS.set_video_mode/#OS.set_video_mode/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/get_instance_ID/get_instance_id/g' {} +

find . -type f -name "*sound_controller.gd" -exec sed -i 's/root.get_node("AudioStreamPlayer")/root.get_node("StreamPlayer")/g' {} +

find . -type f -name "*sound_controller.gd" -exec sed -i 's/set_default_volume_db/set_volume_db/g' {} +

find . -type f -name "*sound_controller.gd" -exec sed -i 's/set_volume(/set_volume_db(/g' {} +

find . -type f -name "*sound_controller.gd" -exec sed -i 's/stream_player.set_loop(true)/#stream_player.set_loop(true)(/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/.is_hidden():/.is_visible() == false:/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/self.root.get_node("\/root").get_rect().size/self.root.get_node("\/root").get_size()/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/event.x/event.get_position().x/g' {} +
find . -type f -name "*.gd" -exec sed -i 's/event.y/event.get_position().y/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/get_tree().call_group(0,/get_tree().call_group(/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/event.relative_x/event.get_relative().x/g' {} +
find . -type f -name "*.gd" -exec sed -i 's/event.relative_y/event.get_relative().y/g' {} +


find . -type f -name "*.gd" -exec sed -i 's/event.type != InputEvent.KEY ||/ /g' {} +

find . -type f -name "*.gd" -exec sed -i 's/OS.get_main_loop().quit()/get_tree().quit()/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/preload/load/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/self.do_awesome_cinematic_pan()/call("do_awesome_cinematic_pan")/g' {} +
find . -type f -name "*.gd" -exec sed -i 's/self.do_awesome_random_explosions()/call("do_awesome_random_explosions")/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/func get(api/func getReq(api/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/func clear_points():/func clear_points(var _empty_anim : String):/g' {} +
find . -type f -name "*.gd" -exec sed -i 's/func _die():/func _die(var _empty_anim : String):/g' {} +

find . -type f -name "*.gd" -exec sed -i 's/self.bag.skirmish_setup.connect(self, "hide_skirmish_setup_panel"/self.bag.skirmish_setup.connectALT(self, "hide_skirmish_setup_panel"/g' {} +

find . -type f -name "*demo_timer.gd" -exec sed -i 's/timeout/timeoutVAR/g' {} +
find . -type f -name "*timers.gd" -exec sed -i 's/(timeout/(timeoutVAR/g' {} +

find . -type f -name "*demo_timer.gd" -exec sed -i 's/is_active/!is_stopped/g' {} +


