Zen.Config.DeathScreen = {
    Buttons = {
        {
            label = 'Grove Street', 
            price = 5000, 
            coords = vec4(-11.0048, -1829.7074, 25.3714, 137.6733), 
            keybind = 'E'
        },
        {
            label = 'Grove Street With AP', 
            price = 50000, 
            coords = vec4(-11.0048, -1829.7074, 25.3714, 137.6733), 
            weapon = 'weapon_appistol', 
            keybind = 'F' 
        },
    },

    OnDeath = {
        RespawnTime = 5000,
        BleedoutTime = 3000 * 60, 
        RemoveLoadout = true,
    },

    PoliceStation = vec4(427.8087, -981.6189, 30.7110, 93.1928),

    Hospitals = {
        Locations = {
            vec4(297.9086, -584.1340, 43.2609, 88.4865),
        },

        Blip = {
            Type = 61, 
            Color = 2, 
            Name = 'Hospital', 
            Scale = 0.6
        }
    },

    ReviveZones = {
        { coords = vec3(297.9086, -584.1340, 43.2609), distance = 15}, -- Hospital
        { coords = vec3(-942.5386, -753.7180, 19.0677), distance = 75 }, -- Skate Ramps
        { coords = vec3(1432.07, 1109.58, 114.30), distance = 100 } -- Stables
    }
}