Zen.Config.Police = {
    CuffAutoRelease = 10, -- MINS

    Blip = { 
        Coords = vec3(438.89, -981.9, 30.68),
        Name = 'Police Station', 
        Type = 60, 
        Color = 84,
        Scale = 0.9
    },

    Station = {
        [1] = {
            label = 'Armory',
            menu = 'armory',
            coords = vec3(482.59, -995.71, 30.69)
        },
        [2] = {
            label = 'Boss Actions',
            menu = 'boss',
            coords = vec3(463.29, -984.8, 30.69),
        },
        [3] = {
            label = 'Evidence Locker',
            menu = 'evidence',
            coords = vec3(485.0978, -999.1735, 30.6896)
        },
        [4] = {
            label = 'Vehicles',
            menu = 'vehicles',
            coords = vector3(457.88, -1017.21, 28.25),
            spawn = vec4(441.9646, -1014.5549, 28.4012, 88.1046),
        },
        [5] = {
            label = 'Helicopters',
            menu = 'helicopters',
            coords = vector3(461.1, -981.5, 43.6),
            spawn = vec4(448.6051, -981.1532, 44.0770, 267.7875),
        },

    },

    MarkerDistance = 3,

    Weapons = {
        ['weapon_pistol50'] = { 
            weapon = 'weapon_pistol50', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_combatpdw'] = { 
            weapon = 'weapon_combatpdw', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_carbinerifle'] = { 
            weapon = 'weapon_carbinerifle', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_pumpshotgun'] = { 
            weapon = 'weapon_pumpshotgun', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_heavysniper'] = { 
            weapon = 'weapon_heavysniper', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_nightstick'] = { 
            weapon = 'weapon_nightstick', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_stungun'] = { 
            weapon = 'weapon_stungun', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['weapon_flashlight'] = { 
            weapon = 'weapon_flashlight', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
    },

    Items = {
        ['clip'] = { 
            item = 'clip', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        ['medkit'] = { 
            item = 'medkit', 
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'detective', 'lieutenant', 'boss' }
        },
    },

    Vehicles = {
        { 
            model = 'police', 
            label = 'Police 1',
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        { 
            model = 'police2', 
            label = 'Police 2',
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
        { 
            model = 'police3', 
            label = 'Police 3',
            price = 1000, 
            ranks = { 'recruit', 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
    },

    Helicopters = {
        { 
            model = 'polmav', 
            label = 'Police Maverick',
            price = 1000, 
            ranks = { 'officer', 'corporal', 'sergeant', 'detective', 'lieutenant', 'boss' }
        },
    },

    Fines = {
        {
            label = "Misuse of a horn",
            amount = 30,
            category = 0
        },
        {
            label = "Illegally Crossing a continuous Line",
            amount = 40,
            category = 0
        },
        {
            label = "Driving on the wrong side of the road",
            amount = 250,
            category = 0
        },
        {
            label = "Illegal U-Turn",
            amount = 250,
            category = 0
        },
        {
            label = "Illegally Driving Off-road",
            amount = 170,
            category = 0
        },
        {
            label = "Refusing a Lawful Command",
            amount = 30,
            category = 0
        },
        {
            label = "Illegally Stopping a Vehicle",
            amount = 150,
            category = 0
        },
        {
            label = "Illegal Parking",
            amount = 70,
            category = 0
        },
        {
            label = "Failing to Yield to the right",
            amount = 70,
            category = 0
        },
        {
            label = "Failure to comply with Vehicle Information",
            amount = 90,
            category = 0
        },
        {
            label = "Failing to stop at a Stop Sign ",
            amount = 105,
            category = 0
        },
        {
            label = "Failing to stop at a Red Light",
            amount = 130,
            category = 0
        },
        {
            label = "Illegal Passing",
            amount = 100,
            category = 0
        },
        {
            label = "Driving an illegal Vehicle",
            amount = 100,
            category = 0
        },
        {
            label = "Driving without a License",
            amount = 1500,
            category = 0
        },
        {
            label = "Hit and Run",
            amount = 800,
            category = 0
        },
        {
            label = "Exceeding Speeds Over < 5 mph",
            amount = 90,
            category = 0
        },
        {
            label = "Exceeding Speeds Over 5-15 mph",
            amount = 120,
            category = 0
        },
        {
            label = "Exceeding Speeds Over 15-30 mph",
            amount = 180,
            category = 0
        },
        {
            label = "Exceeding Speeds Over > 30 mph",
            amount = 300,
            category = 0
        },
        {
            label = "Impeding traffic flow",
            amount = 110,
            category = 1
        },
        {
            label = "Public Intoxication",
            amount = 90,
            category = 1
        },
        {
            label = "Disorderly conduct",
            amount = 90,
            category = 1
        },
        {
            label = "Obstruction of Justice",
            amount = 130,
            category = 1
        },
        {
            label = "Insults towards Civilans",
            amount = 75,
            category = 1
        },
        {
            label = "Disrespecting of an LEO",
            amount = 110,
            category = 1
        },
        {
            label = "Verbal Threat towards a Civilan",
            amount = 90,
            category = 1
        },
        {
            label = "Verbal Threat towards an LEO",
            amount = 150,
            category = 1
        },
        {
            label = "Providing False Information",
            amount = 250,
            category = 1
        },
        {
            label = "Attempt of Corruption",
            amount = 1500,
            category = 1
        },
        {
            label = "Brandishing a weapon in city Limits",
            amount = 120,
            category = 2
        },
        {
            label = "Brandishing a Lethal Weapon in city Limits",
            amount = 300,
            category = 2
        },
        {
            label = "No Firearms License",
            amount = 600,
            category = 2
        },
        {
            label = "Possession of an Illegal Weapon",
            amount = 700,
            category = 2
        },
        {
            label = "Possession of Burglary Tools",
            amount = 300,
            category = 2
        },
        {
            label = "Grand Theft Auto",
            amount = 1800,
            category = 2
        },
        {
            label = "Intent to Sell/Distrube of an illegal Substance",
            amount = 1500,
            category = 2
        },
        {
            label = "Frabrication of an Illegal Substance",
            amount = 1500,
            category = 2
        },
        {
            label = "Possession of an Illegal Substance ",
            amount = 650,
            category = 2
        },
        {
            label = "Kidnapping of a Civilan",
            amount = 1500,
            category = 2
        },
        {
            label = "Kidnapping of an LEO",
            amount = 2000,
            category = 2
        },
        {
            label = "Robbery",
            amount = 650,
            category = 2
        },
        {
            label = "Armed Robbery of a Store",
            amount = 650,
            category = 2
        },
        {
            label = "Armed Robbery of a Bank",
            amount = 1500,
            category = 2
        },
        {
            label = "Assault on a Civilian",
            amount = 2000,
            category = 3
        },
        {
            label = "Assault of an LEO",
            amount = 2500,
            category = 3
        },
        {
            label = "Attempt of Murder of a Civilian",
            amount = 3000,
            category = 3
        },
        {
            label = "Attempt of Murder of an LEO",
            amount = 5000,
            category = 3
        },
        {
            label = "Murder of a Civilian",
            amount = 10000,
            category = 3
        },
        {
            label = "Murder of an LEO",
            amount = 30000,
            category = 3
        },
        {
            label = "Involuntary manslaughter",
            amount = 1800,
            category = 3
        },
        {
            label = "Fraud",
            amount = 2000,
            category = 2
        }
    }
}