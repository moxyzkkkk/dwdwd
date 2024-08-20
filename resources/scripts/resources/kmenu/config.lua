Zen.Config.KMenu = {
    Locations = {
        { vec3(-924.37,-753.8,19.63), 73 }, -- Skate Park
        { vec3(-1020.0,-3453.26,13.91144), 250 }, -- Airport Ramps
        { vec3(1414.78, 1119.6, 114.83), 140 }, -- Stables
    },

    Buttons = {
        Teleports = {
            ['Category 1'] = {
                -- { 'icon', 'label', coords }
                { 'Skate Ramps', vec4(-959.07,-779.92,17.82, 31.43) },
                { 'Airport Ramps', vec4(-1024.20, -3452.72, 13.94, 31.43) },
                { 'Stables', vec4(1432.07, 1109.58, 114.30, 31.43) },
            },
        },

        Weapons = {
            ['weapon_appistol'] = { 
                weapon = 'weapon_appistol', 
                price = 50000 
            },
            ['weapon_combatpistol'] = { 
                weapon = 'weapon_combatpistol', 
                price = 30000 
            },
        },

        Items = {
            ['armour'] = {
                item = 'armour',
                icon = 'shield',
                price = 500
            },
            ['clip'] = {
                item = 'clip',
                icon = 'gun',
                price = 500
            },
            ['medkit'] = {
                item = 'medkit',
                icon = 'suitcase-medical',
                price = 500
            },
        }
    }
}