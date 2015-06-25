
var maps = [
    {
        'label': 'MayDay Square',
        'player': 0,
        'file': preload("res://maps/campaign/maidan.gd").new(),
        'description': 'AFTER DAYS OF PROTESTS, WE FINALLY SAY ENOUGH IS ENOUGH. CORRUPTION AND ABUSE HAS TO STOP! PROTESTERS OF MAYDAY SQUARE ARE READY TO FIGHT! TAKE COMMAND OF THE FREEDOM FIGHTERS AND ASSAULT PRESIDENTAL PALACE.'
    },
    {
        'label': 'Eastern city',
        'player': 0,
        'file': preload("res://maps/campaign/eastern_city.gd").new(),
        'description': 'Even though the events of Mayday Square allowed for relatively peacefull change of government, there is still a lot of tension. We have reports of group of militiants loyal to the old president. Find and capture their center of operations before their actions cause civil war.'
    },
    {
        'label': 'Riots',
        'player': 1,
        'file': preload("res://maps/campaign/administration_riot.gd").new(),
        'description': 'Current government came to power by attacking our dear leader! And they dare to call us the rebels! New authorities are still weak. We should use this opportunity to take over key administration offices. Our forces are stanging by and awaiting your orders!'
    },
    {
        'label': 'Base Assault',
        'player': 1,
        'file': preload("res://maps/campaign/base_assault.gd").new(),
        'description': 'Our recent victory gave us a foothold, but we can not stop there. Nearby military base has a lot of equipment we could use! We have to attack before they realise, that they are no longer in controll of this region.'
    },
    {
        'label': 'Peninsula',
        'player': 1,
        'file': preload("res://maps/campaign/peninsula.gd").new(),
        'description': 'Days of fighting are finnally paying off. Now we have support from our strong neighbouring country as well. We are ready to push the usurpers out of the peninsula. When we succeed, there will be no way for them to re-take it. This will be our great victory!'
    },
    {
        'label': 'Recapture',
        'player': 0,
        'file': preload("res://maps/campaign/administration_recapture.gd").new(),
        'description': 'Situation is deteriorating quickly. We have to start pushing back, or we will loose all of our progress in this conflict. We are ready to liberate city where the rebels began their operations. Let us show them, that simple bandits are no match for our military.'
    },
    {
        'label': 'Base Defence',
        'player': 0,
        'file': preload("res://maps/campaign/base_defence.gd").new(),
        'description': 'Alert! Rebels are attacking one of our military bases in the eastern region! We must not allow them to capture more equipment. Defend the base and destroy rebel forces in the region.'
    },
    {
        'label': 'Airport Pt.1',
        'player': 1,
        'file': preload("res://maps/campaign/airport_part_1.gd").new(),
        'description': 'Fighting between our militia and government forces is not going as good as we would hope. We need to show them, that we are a force to be reckoned with. Nearby airport is not of huge strategic importance, but it will be our manifestation of power! Capture it!'
    },
    {
        'label': 'Airplane',
        'player': 1,
        'file': preload("res://maps/campaign/airplane.gd").new(),
        'description': 'We have intercepted a transmission about important military airplane, that will be flying over the area. We have identified perfect spot to launch missiles from, but it is guarded by the enemy. Muster your forces and get into position to shoot down the transport.'
    },
    {
        'label': 'Field Command',
        'player': 0,
        'file': preload("res://maps/campaign/field_command.gd").new(),
        'description': 'These separatists just shot down a civilian airplane, hundreds of people died. Their violence has to stop! Our scouts found the enemy field command center for this region. Our forces are small, but we should be able to gather more men and tanks in the nearby city.'
    },
    {
        'label': 'Airport Pt.2',
        'player': 0,
        'file': preload("res://maps/campaign/airport_part_2.gd").new(),
        'description': 'Rebel forces are in chaos after loosing their local HQ. Airport is still heavily guarded, but they will not recieve new reinforcements anytime soon. We managed to set up a small base. We have to attack before they can pick themselves up.'
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
        'description': 'Plane we attacked went down deep within the forest. We must not allow anyone to reach the crash site. Without the wreckage, no one will be able to proove who and how destroyed it. International investigators are on their way, we have to stop them.'
    },
]

func get_map_data(map_name):
    return maps[map_name]['file']

func get_map_player(map_name):
    return maps[map_name]['player']

func get_map_description(map_name):
    return maps[map_name]['description']