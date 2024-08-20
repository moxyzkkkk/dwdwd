Zen.Config.AdminMenu = {
    OpenMenu = {
        Command = 'adminmenu',
        Keybind = 'F9'
    },

    Bans = {
        Lengths = {
            ['6 Hours'] = Zen.Counter['Hour'] * 6,
            ['12 Hours'] = Zen.Counter['Hour'] * 12,
            ['3 Days'] = Zen.Counter['Day'] * 3,
            ['1 Week'] = Zen.Counter['Week'],
            ['1 Month'] = Zen.Counter['Month'],
            ['3 Months'] = Zen.Counter['Month'] * 3,
            ['6 Months'] = Zen.Counter['Month'] * 6,
            ['1 Year'] = Zen.Counter['Year'],
            ['Permanent'] = Zen.Counter['Year'] * 5 
        }
    },
    
    -- if empty they can spawn any car
    SpawnCar = { 
        ['manchez'] = 'Manchez', 
        ['blista'] = 'Blista', 
        ['t20'] = 'T20', 
        ['insurgent'] = 'Insurgent'
    }
}

