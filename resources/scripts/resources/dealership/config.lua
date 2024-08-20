Zen.Config.DealerShip = {
    TestDrive = {
        Timer = 1, -- mins
        Coords = vec4(-47.48, -1074.55, 26.81, 69.68)
    },

    Coords = {
        Enter = vec3(-33.43, -1101.84, 26.42), -- Enter Marker
        Spawn = vec4(-13.37, -1088.09, 26.69, 165.14), -- After Purchase
        Vehicle = vec4(-46.03, -1097.27, 26.43, 211.1), -- Preview Spawn
        Camera = vec4(-39.36, -1101.25, 26.42, 60.39) -- Preview Camera
    },

    Blip = { 
        Name = 'Dealership', 
        Type = 523, 
        Color = 59 
    },

    Vehicles = {
        {
            name = "donor",
            label = "Donors",
            giveable = false,
            role = 756878470889340999,
            vehicles = {
                { label = 'Issi', model = "issi2", price = 10000 },
                { label = 'Prairie', model = "prairie", price = 12000 },
                { label = 'Panto', model = "panto", price = 10000 },
                { label = 'brioso', model = "brioso", price = 18000 },
                { label = 'Blista', model = "blista", price = 8000 },
            }
        },
        {
            name = "coupes",
            label = "Coupés",
            giveable = true,
            vehicles = {
                { label = 'Sentinel', model = "sentinel", price = 32000 },
                { label = 'Sxemplar', model = "exemplar", price = 32000 },
                { label = 'Zion2', model = "zion2", price = 45000 },
            }
        },
        {
            name = "motorcycles",
            label = "Motos",
            giveable = true,
            vehicles = {
                { label = 'Sanctus', model = "sanctus", price = 25000 },
                { label = 'Innovation', model = "innovation", price = 23500 },
                { label = 'Hexer', model = "hexer", price = 12000 },
            }
        },
        {
            name = "muscle",
            label = "Muscle",
            giveable = true,
            vehicles = {
                { label = 'Sabregt', model = "sabregt2", price = 25000 },
                { label = 'Hustler', model = "hustler", price = 625000 },
                { label = 'Chino', model = "chino", price = 15000 },
            }
        },
        {
            name = "offroad",
            label = "Off Road",
            giveable = true,
            vehicles = {
                { label = 'F-150 Lightning', model = "foxlight", price = 55000 },
                { label = 'Riata', model = "riata", price = 380000 },
                { label = 'Monster', model = "monster", price = 210000 },
            }
        },
        {
            name = "sedans",
            label = "Sedans",
            giveable = true,
            vehicles = {
                { label = 'Stretch', model = "stretch", price = 90000 },
                { label = 'Glendale', model = "glendale", price = 6500 },
                { label = 'Superd', model = "superd", price = 130000 },
            }
        },
        {
            name = "sports",
            label = "Sports",
            giveable = true,
            vehicles = {
                { label = 'Buffalo', model = "buffalo", price = 12000 },
                { label = 'Buffalo 2', model = "buffalo2", price = 20000 },
                { label = 'Ninef', model = "ninef2", price = 80000 },
            }
        },
        {
            name = "sportsclassics",
            label = "Sports Classics",
            giveable = true,
            vehicles = {
                { label = 'Z-Type', model = "ztype", price = 220000 },
                { label = 'Z190', model = "z190", price = 900000 },
                { label = 'Savestra', model = "savestra", price = 990000 },
            }
        },
        {
            name = "super",
            label = "Super",
            giveable = true,
            vehicles = {
                { label = 'Adder', model = "adder", price = 900000 },
                { label = 'Entityxf', model = "entityxf", price = 425000 },
                { label = 'FMJ', model = "fmj", price = 185000 },
            }
        },
        {
            name = "suvs",
            label = "SUVs",
            giveable = true,
            vehicles = {
                { label = 'XLS', model = "xls", price = 32000 },
                { label = 'Cavalcade', model = "cavalcade2", price = 55000 },
                { label = 'Radi', model = "radi", price = 29000 },
            }
        },
        {
            name = "vans",
            label = "Vans",
            giveable = true,
            vehicles = {
                { label = 'Surfer', model = "surfer", price = 12000 },
                { label = 'Moonbeam', model = "moonbeam2", price = 35000 },
                { label = 'Gburrito', model = "gburrito", price = 45000 },
            }
        }   
    }
}