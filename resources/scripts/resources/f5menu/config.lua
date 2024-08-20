Zen.Config.F5Menu = {
    MainMenu = {
        {
            label = 'Weather Options',
            icon = 'cloud',
            args = {
                menu = 'f5WeatherMenu'
            }
        },
        {
            label = 'Ped Menu',
            icon = 'user-pen',
            args = {
                menu = 'f5PedMenu'
            }
        },
        {
            label = 'ChatTag Menu',
            icon = 'user-tag',
            args = {
                menu = 'f5ChatTagMenu'
            }
        },
        {
            label = 'Custom Colors',
            icon = 'fill',
            args = {
                menu = 'f5CustomColors'
            }
        },
        -- { [[ Example With Role Needed To Open Menu ]]
        --     label = 'Donor VIP Menu',
        --     icon = 'star',
        --     args = {
        --         menu = 'f5DonorVipMenu',
        --         role = 960372208767742002
        --     }
        -- }
    },

    ChatTagMenu = {
        Default = {
            tag = 'Thug',
            color = '255, 0, 255'
        },

        Tags = {
            {
                tag = 'Owner',
                color = '190, 0, 0',
                role = 9603722087677422002
            },
        },

        CustomChatTag = {
            role = 960372208767742002,
            
            tag = {
                min = 2,
                max = 15
            },

            blacklisted = { 'nigger' }
        }
    },

    PedMenu = {
        {
            label = 'Donor Peds',
            role = 960372208767742002,
            options = {
                { 'Onesie', 'a_f_m_beach_01' },
                { 'Travis Scott', 'TravisScott' },
                { 'Fall Guys', 'fallguyslpink' },
                { 'Sponge Bob', 'BOB ESPONJA' },
                { 'Squidward', 'Calamardo' },
                { 'Patrick', 'patrick' },
                { 'Mr. Krabs', 'Krabs' },
                { 'Iron Spiderman', 'IronSpiderman_PS4' },
                { 'Donkey Kong', 'DonkeyKong' },
                { 'Ned Flanders', 'Ned' },
                { 'Marge Simpson', 'Marge' },
                { 'Lisa Simpson', 'Lisa' },
                { 'Moe Simpson', 'Moe' },
                { 'Krusty The Clown', 'Krusty' },
                { 'Snake Jailbird', 'Snake' },
                { 'Homer Simpson', 'Homer' },
                { 'Apu Simpson', 'Apu' },
                { 'Abe Simpson', 'Abe' },
                { 'Burns Simpson', 'Burns' },
                { 'Carl Simpson', 'Carl' },
                { 'Barney Simpson', 'Barney' },
                { 'Lenny Simpson', 'Lenny' },
                { 'Shrek', 'shrek' },
                { 'Superman', 'SupermanTheMovie' },
                { 'The Flash', 'TheFlash' },
                { 'Green Lantern', 'GreenLantern' },
                { 'Thanos', 'THANOS4' },
                { 'Hulk ', 'hulk' },
                { 'Wallace', 'Wallace' },
                { 'Gromit', 'Gromit' },
                { 'Hulk Buster', 'HulkBusterB' },
                { 'Elmo', 'ELMO' },
                { 'Bender', 'Bender' },
                { 'Vanellope', 'Vanellope' },
                { 'Minecraft Steve', 'steve' },
                { 'Angry Bird', 'abirdred' },
                { 'Slender Man', 'SlenderMan' },
                { '[LEGO] The Flash', 'Flash LEGO' },
                { 'PacMan', 'Pac-Man' },
                { 'Super Mario', 'Mario_MTUS' },
                { 'Luigi', 'Luigi_MTUS' },
                { 'Wario ', 'Wario' },
                { 'Waluigi', 'Waluigi' },
                { 'Baby Mario', 'BabyMario' },
                { 'Baby Luigi', 'BabyLuigi' } 
            }
        },
    }
}