
var progress_file = File.new()
var campaign_progression = -1

var maps = [
    {
        'label': 'MayDay Square',
        'player': 0,
        'file': preload("res://maps/campaign/maidan.gd").new(),
        'description': 'After days of protests, we finally say enough is enough. Corruption and abuse has to stop! Protesters of Mayday Square are ready to fight! Take command of the freedom fighters and assault Presidental Palace.'
    },
    {
        'label': 'Eastern city',
        'player': 0,
        'file': preload("res://maps/campaign/eastern_city.gd").new(),
        'description': 'Even though the events of Mayday Square allowed for relatively peacefull change of government, there is still a lot of tension. We have reports of a group of militiants loyal to the old president. Find and capture their center of operations before their actions cause civil war.'
    },
    {
        'label': 'Riots',
        'player': 1,
        'file': preload("res://maps/campaign/administration_riot.gd").new(),
        'description': 'Current government came to power by attacking our dear leader! And they dare to call us the rebels! New authorities are still weak. We should use this opportunity to take over key administration offices. Our forces are standing by and awaiting your orders!'
    },
    {
        'label': 'Base Assault',
        'player': 1,
        'file': preload("res://maps/campaign/base_assault.gd").new(),
        'description': 'Our recent victory gave us a foothold, but we can not stop there. Nearby military base has a lot of equipment we could use! We have to attack before they realise, that they are no longer in control of this region.'
    },
    {
        'label': 'Peninsula',
        'player': 1,
        'file': preload("res://maps/campaign/peninsula.gd").new(),
        'description': 'Days of fighting are finnally paying off. Now we have the support of our strong neighbouring country. We are ready to push the usurpers out of the peninsula. When we succeed, there will be no way for them to re-take it. This will be our great victory!'
    },
    {
        'label': 'Recapture',
        'player': 0,
        'file': preload("res://maps/campaign/administration_recapture.gd").new(),
        'description': 'Situation is deteriorating quickly. We have to start pushing back, or we will loose all of our progress in this conflict. We are ready to liberate the city, where the rebels began their operations. Let us show them, and the people, that simple bandits are no match for our military.'
    },
    {
        'label': 'Base Defence',
        'player': 0,
        'file': preload("res://maps/campaign/base_defence.gd").new(),
        'description': 'Alert! Rebels are attacking one of our military bases in the eastern region! We must not allow them to capture any more of our assets. Defend the base and destroy the rebel forces in the region.'
    },
    {
        'label': 'Airport Pt.1',
        'player': 1,
        'file': preload("res://maps/campaign/airport_part_1.gd").new(),
        'description': 'Fighting between our militia and the government forces is not going as good as we would hope. We need to show the world, that we are not giving up just yet. Nearby airport is not of huge strategic importance, but capturing it will be our manifestation of power!'
    },
    {
        'label': 'Airplane',
        'player': 1,
        'file': preload("res://maps/campaign/airplane.gd").new(),
        'description': 'Thanks to the airport equipment, we have intercepted a transmission about an important military airplane, that will be flying over the area. We have identified the perfect spot to launch missiles from, but it is guarded by the enemy. Muster your forces and get into position to shoot down the transport.'
    },
    {
        'label': 'Field Command',
        'player': 0,
        'file': preload("res://maps/campaign/field_command.gd").new(),
        'description': 'These separatists just shot down a civilian airplane, hundreds of people died. Their violence has to stop! Our scouts have found the enemy field command center for this region. Our resources are limited, but we should be able to gather more men and tanks in the nearby city.'
    },
    {
        'label': 'Airport Pt.2',
        'player': 0,
        'file': preload("res://maps/campaign/airport_part_2.gd").new(),
        'description': 'The rebel forces have scattered after loosing their local HQ. The Airport is still heavily guarded, but they will not recieve any new reinforcements anytime soon. Recon team managed to set up a small base. We have to attack before they can pick themselves up.'
    },
    {
        'label': 'Convoy',
        'player': 1,
        'file': preload("res://maps/campaign/convoy.gd").new(),
        'description': 'In this time of war many people are suffering. Our kind neighbour offered to send us humanitarian convoy with food, water and medicine. Government does not believe in our good intentions, not allowing the trucks to pass. We have to clear the way!'
    },
    {
        'label': 'Crash Site',
        'player': 1,
        'file': preload("res://maps/campaign/crash_site.gd").new(),
        'description': 'The Plane we attacked went down deep within the forest. We must not allow anyone to reach the crash site. Without the wreckage, no one will be able to proove who and how destroyed it. International investigators are on their way, we have to stop them.'
    },
    {
        'label': 'Airport Pt.3',
        'player': 1,
        'file': preload("res://maps/campaign/airport_part_3.gd").new(),
        'description': 'It has been months since we started fighting over this wretched airport. It is hardly an airport anymore either, with everything reduced to rubble - the terminal, the tower, surrounding city. Even so, it is still a symbol of who has the upper hand here, and it should be ours!'
    },
]

func get_map_data(map_number):
    return maps[map_number]['file']

func get_map_player(map_number):
    return maps[map_number]['player']

func get_map_description(map_number):
    return maps[map_number]['description']

func get_map_name(map_number):
    return maps[map_number]['label']

func load_campaign_progress():
    if progress_file.file_exists("user://campaign_progress.tof"):
        progress_file.open("user://campaign_progress.tof",File.READ)
        self.campaign_progression = progress_file.get_var()
    else:
        self.update_campaign_progress(self.campaign_progression)

func get_campaign_progress():
    return self.campaign_progression

func get_completed_map_count():
    var completed_num = self.campaign_progression + 1
    if completed_num > self.maps.size():
        completed_num = self.maps.size()
    return completed_num

func update_campaign_progress(map_number):
    self.campaign_progression = map_number
    progress_file.open("user://campaign_progress.tof",File.WRITE)
    progress_file.store_var(map_number)
    progress_file.close()
