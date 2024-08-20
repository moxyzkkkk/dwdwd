Zen = {}
Zen.Config = {}

Zen.Jobs = {
    ['unemployed'] = {
        name = 'unemployed',
        label = 'Unemployed',
        grades = {
            ['0'] = { grade = 0, name = 'unemployed', label = 'Unemployed', salary = 5000 }
        }
    },

    ['police'] = {
        name = 'police',
        label = 'Police',
        grades = {
            ['0'] = { grade = 0, name = "recruit", label = "Recruit", salary = 8000 },
            ['1'] = { grade = 1, name = "officer", label = "Officer", salary = 12000 },
            ['2'] = { grade = 2, name = "sergeant", label = "Sergeant", salary = 16000 },
            ['3'] = { grade = 3, name = "lieutenant", label = "Lieutenant", salary = 20000 },
            ['4'] = { grade = 4, name = "boss", label = "Chief", salary = 50000 }
        }
    },
    
    ['offpolice'] = {
        name = 'offpolice',
        label = 'OFF',
        grades = {
            ['0'] = { grade = 0, name = "recruit", label = "DUTY", salary = 8000 },
            ['1'] = { grade = 1, name = "officer", label = "DUTY", salary = 12000 },
            ['2'] = { grade = 2, name = "sergeant", label = "DUTY", salary = 16000 },
            ['3'] = { grade = 3, name = "lieutenant", label = "DUTY", salary = 20000 },
            ['4'] = { grade = 4, name = "boss", label = "DUTY", salary = 50000 }
        }
    },
}

Zen.Items = {
    ["clip"] = { name = "clip", label = "Weapon Clip", canRemove = true, limit = 100 },
    ["medkit"] = { name = "medkit", label = "MedKit", canRemove = true, limit = 100 },
    ["armour"] = { name = "armour", label = "Armour", canRemove = false, limit = 250 },
    ["repairkit"] = { name = "repairkit", label = "Repair Kit", canRemove = true, limit = 10 },
    ["tunerchip"] = { name = "tunerchip", label = "Tuner Chip", canRemove = true, limit = 1 },
    ["suppressor"] = { name = "suppressor", label = "Suppressor", canRemove = true, limit = 5 },
    
    ["weed"] = { name = "weed", label = "Weed", canRemove = true, limit = 150 },
    ["weed_pouch"] = { name = "weed_pouch", label = "Weed Pouch", canRemove = true, limit = 15 },
    ["cocaine"] = { name = "cocaine", label = "Cocaine", canRemove = true, limit = 200 },
    ["cocaine_pouch"] = { name = "cocaine_pouch", label = "Cocaine Baggie", canRemove = true, limit = 20 },
    ["codiene"] = { name = "codiene", label = "Codiene", canRemove = true, limit = 200 },
    ["codiene_pouch"] = { name = "codiene_pouch", label = "Codiene Syrup", canRemove = true, limit = 20 },
    ["fentanyl"] = { name = "fentanyl", label = "Fentanyl", canRemove = true, limit = 200 },
    ["fentanyl_pouch"] = { name = "fentanyl_pouch", label = "Fentanyl Single Dose", canRemove = true, limit = 20 },
	["lean"] = { name = "lean", label = "Lean", canRemove = true, limit = 200 },
    ["lean_pouch"] = { name = "lean_pouch", label = "Lean Cup", canRemove = true, limit = 20 },
	["meth"] = { name = "meth", label = "Meth", canRemove = true, limit = 200 },
    ["meth_pouch"] = { name = "meth_pouch", label = "Meth Baggie", canRemove = true, limit = 20 },
	["opium"] = { name = "opium", label = "Opium", canRemove = true, limit = 200 },
    ["opium_pouch"] = { name = "opium_pouch", label = "Opium Brick", canRemove = true, limit = 20 },
	["percocet"] = { name = "percocet", label = "Percocet", canRemove = true, limit = 200 },
    ["percocet_pouch"] = { name = "percocet_pouch", label = "Percocet Bottle", canRemove = true, limit = 20 },
	["xanax"] = { name = "xanax", label = "Xanax", canRemove = true, limit = 200 },
    ["xanax_pouch"] = { name = "xanax_pouch", label = "Xanax Tablets", canRemove = true, limit = 20 },
}

-- you do not need to touch ANY of these
Zen.Accounts = { ['black_money'] = 'Dirty Cash', ['bank'] = 'Bank', ['money'] = 'Cash' }
Zen.Keys = { ["A"] = 34, ["B"] = 29, ["C"] = 26, ["D"] = 30, ["E"] = 38, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["I"] = 20, ["J"] = 36, ["K"] = 37, ["L"] = 38, ["M"] = 32, ["N"] = 49, ["O"] = 24, ["P"] = 25, ["Q"] = 44, ["R"] = 45, ["S"] = 33, ["T"] = 23, ["U"] = 303, ["V"] = 0, ["W"] = 32, ["X"] = 73, ["Y"] = 246, ["Z"] = 20, ["0"] = 11, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["~"] = 243, ["-"] = 84, ["="] = 83, ["Backspace"] = 177, ["Tab"] = 37, ["CapsLock"] = 137, ["Enter"] = 176, ["Shift"] = 21, ["Ctrl"] = 36, ["Alt"] = 19, ["Pause"] = 22, ["PageUp"] = 10, ["PageDown"] = 11, ["End"] = 30, ["Home"] = 36, ["Insert"] = 73, ["Delete"] = 76, ["UpArrow"] = 32, ["DownArrow"] = 33, ["LeftArrow"] = 34, ["RightArrow"] = 35, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F4"] = 166, ["F5"] = 167, ["F6"] = 168, ["F7"] = 169, ["F8"] = 56, ["F9"] = 57, ["F10"] = 344, ["F11"] = 345, ["F12"] = 346, ["NumLock"] = 37, ["ScrollLock"] = 70, [";"] = 74, [","] = 51, ["."] = 72, ["/"] = 45, ["'"] = 243, ["["] = 44, ["]"] = 32, ["\\"] = 36 }
Zen.Weapons = { ['weapon_unarmed'] = 'Fists', ['weapon_knife'] = 'Knife', ['weapon_nightstick'] = 'Nightstick', ['weapon_hammer'] = 'Hammer', ['weapon_bat'] = 'Baseball Bat', ['weapon_golfclub'] = 'Golf Club', ['weapon_crowbar'] = 'Crowbar', ['weapon_pistol'] = 'Pistol', ['weapon_combatpistol'] = 'Combat Pistol', ['weapon_appistol'] = 'AP Pistol', ['weapon_pistol50'] = 'Pistol .50', ['weapon_microsmg'] = 'Micro SMG', ['weapon_smg'] = 'SMG', ['weapon_assaultsmg'] = 'Assault SMG', ['weapon_assaultrifle'] = 'Assault Rifle', ['weapon_carbinerifle'] = 'Carbine Rifle', ['weapon_advancedrifle'] = 'Advanced Rifle', ['weapon_mg'] = 'MG', ['weapon_combatmg'] = 'Combat MG', ['weapon_pumpshotgun'] = 'Pump Shotgun', ['weapon_sawnoffshotgun'] = 'Sawed-Off Shotgun', ['weapon_assaultshotgun'] = 'Assault Shotgun', ['weapon_bullpupshotgun'] = 'Bullpup Shotgun', ['weapon_stungun'] = 'Stun Gun', ['weapon_sniperrifle'] = 'Sniper Rifle', ['weapon_heavysniper'] = 'Heavy Sniper', ['weapon_grenadelauncher'] = 'Grenade Launcher', ['weapon_rpg'] = 'RPG', ['weapon_minigun'] = 'Minigun', ['weapon_grenade'] = 'Grenade', ['weapon_stickybomb'] = 'Sticky Bomb', ['weapon_smokegrenade'] = 'Smoke Grenade', ['weapon_bzgas'] = 'BZ Gas', ['weapon_molotov'] = 'Molotov Cocktail', ['weapon_fireextinguisher'] = 'Fire Extinguisher', ['weapon_petrolcan'] = 'Jerry Can', ['weapon_ball'] = 'Baseball', ['weapon_snspistol'] = 'SNS Pistol', ['weapon_bottle'] = 'Broken Bottle', ['weapon_gusenberg'] = 'Gusenberg Sweeper', ['weapon_specialcarbine'] = 'Special Carbine', ['weapon_heavypistol'] = 'Heavy Pistol', ['weapon_bullpuprifle'] = 'Bullpup Rifle', ['weapon_dagger'] = 'Dagger', ['weapon_vintagepistol'] = 'Vintage Pistol', ['weapon_firework'] = 'Firework Launcher', ['weapon_musket'] = 'Musket', ['weapon_heavyshotgun'] = 'Heavy Shotgun', ['weapon_marksmanrifle'] = 'Marksman Rifle', ['weapon_hominglauncher'] = 'Homing Launcher', ['weapon_proxmine'] = 'Proximity Mines', ['weapon_snowball'] = 'Snowball', ['weapon_flaregun'] = 'Flare Gun', ['weapon_garbagebag'] = 'Garbage Bag', ['weapon_handcuffs'] = 'Handcuffs', ['weapon_combatpdw'] = 'Combat PDW', ['weapon_marksmanpistol'] = 'Marksman Pistol', ['weapon_knuckle'] = 'Knuckle Dusters', ['weapon_hatchet'] = 'Hatchet', ['weapon_railgun'] = 'Railgun', ['weapon_machete'] = 'Machete', ['weapon_machinepistol'] = 'Machine Pistol', ['weapon_switchblade'] = 'Switchblade', ['weapon_revolver'] = 'Heavy Revolver', ['weapon_heavyrifle'] = 'Heavy Rifle', ['weapon_dbshotgun'] = 'Double Barrel Shotgun', ['weapon_compactrifle'] = 'Compact Rifle', ['weapon_autoshotgun'] = 'Sweeper Shotgun', ['weapon_battleaxe'] = 'Battle Axe', ['weapon_compactlauncher'] = 'Compact Grenade Launcher', ['weapon_minismg'] = 'Mini SMG', ['weapon_pipebomb'] = 'Pipe Bomb', ['weapon_poolcue'] = 'Pool Cue', ['weapon_wrench'] = 'Wrench', ['weapon_autoshotgun'] = 'Sweeper Shotgun', ['weapon_bread'] = 'Piece of Bread', ['weapon_stone_hatchet'] = 'Stone Hatchet', ['weapon_hominglauncher'] = 'Homing Launcher', ['weapon_rayminigun'] = 'Unholy Hellbringer', ['weapon_raycarbine'] = 'Widowmaker', ['weapon_bzgas'] = 'BZ Gas', ['weapon_compactgrenadelauncher'] = 'Compact Grenade Launcher', ['weapon_smugglerpistol'] = 'Up-n-Atomizer', ['weapon_raypistol'] = 'Pistol .50', ['weapon_perico_pistol'] = 'Ceramic Pistol', ['weapon_carbinerifle_mk2'] = 'Carbine Rifle Mk II', ['weapon_combatmg_mk2'] = 'Combat MG Mk II', ['weapon_heavysniper_mk2'] = 'Heavy Sniper Mk II', ['weapon_marksmanrifle_mk2'] = 'Marksman Rifle Mk II', ['weapon_pumpshotgun_mk2'] = 'Pump Shotgun Mk II', ['weapon_smg_mk2'] = 'SMG Mk II', ['weapon_raycarbine_mk2'] = 'Widowmaker Mk II', ['weapon_machete'] = 'Machete', ['weapon_flashlight'] = 'Flashlight', ['weapon_hazardousknife'] = 'Hazardous Knife', ['weapon_navyrevolver'] = 'Navy Revolver', ['weapon_ball'] = 'Baseball', ['weapon_golfball'] = 'Golf Ball', ['weapon_snowball'] = 'Snowball', }
Zen.HashKey = { [1317494643] = "weapon_hammer", [2024373456] = "weapon_smg_mk2", [-1654528753] = "weapon_bullpupshotgun", [2132975508] = "weapon_bullpuprifle", [1980066947] = "weapon_compactgrenadelauncher", [1627465347] = "weapon_gusenberg", [-270015777] = "weapon_assaultsmg", [317205821] = "weapon_autoshotgun", [-1063057011] = "weapon_specialcarbine", [1593441988] = "weapon_combatpistol", [-1501891397] = "weapon_smugglerpistol", [-1398540680] = "weapon_perico_pistol", [419712736] = "weapon_wrench", [-598887786] = "weapon_marksmanpistol", [1119849093] = "weapon_minigun", [-1716589765] = "weapon_pistol50", [-37975472] = "weapon_smokegrenade", [-771403250] = "weapon_heavypistol", [-1786099057] = "weapon_bat", [2017895192] = "weapon_sawnoffshotgun", [125959754] = "weapon_compactlauncher", [-1569615261] = "weapon_unarmed", [1309015656] = "weapon_bread", [-538741184] = "weapon_switchblade", [-947031628] = "weapon_heavyrifle", [1834241177] = "weapon_railgun", [-1074790547] = "weapon_assaultrifle", [-952879014] = "weapon_marksmanrifle", [-1660422300] = "weapon_mg", [-1076751822] = "weapon_snspistol", [-499989876] = "weapon_garbagebag", [-809611085] = "weapon_raycarbine_mk2", [-619010992] = "weapon_machinepistol", [-1814108143] = "weapon_hazardousknife", [-494615257] = "weapon_assaultshotgun", [-1357824103] = "weapon_advancedrifle", [-1600701090] = "weapon_bzgas", [-656458692] = "weapon_knuckle", [-1951375401] = "weapon_flashlight", [-2067956739] = "weapon_crowbar", [1432025498] = "weapon_pumpshotgun_mk2", [100416529] = "weapon_sniperrifle", [1785463520] = "weapon_marksmanrifle_mk2", [177293209] = "weapon_heavysniper_mk2", [-608341376] = "weapon_combatmg_mk2", [-86904375] = "weapon_carbinerifle_mk2", [-1355376991] = "weapon_raypistol", [2144741730] = "weapon_combatmg", [1649403952] = "weapon_compactrifle", [-1238556825] = "weapon_rayminigun", [1141786504] = "weapon_golfclub", [584646201] = "weapon_appistol", [984333226] = "weapon_heavyshotgun", [-1810795771] = "weapon_poolcue", [-1169823560] = "weapon_pipebomb", [205991906] = "weapon_heavysniper", [1737195953] = "weapon_nightstick", [-1121678507] = "weapon_minismg", [1672152130] = "weapon_hominglauncher", [-1716189206] = "weapon_knife", [453432689] = "weapon_pistol", [-853065399] = "weapon_battleaxe", [1198256469] = "weapon_raycarbine", [-2084633992] = "weapon_carbinerifle", [-102323637] = "weapon_bottle", [-1045183535] = "weapon_revolver", [-1420407917] = "weapon_proxmine", [-1834847097] = "weapon_dagger", [-1312131151] = "weapon_rpg", [-102973651] = "weapon_hatchet", [171789620] = "weapon_combatpdw", [-800287667] = "weapon_handcuffs", [615608432] = "weapon_molotov", [126349499] = "weapon_snowball", [600439132] = "weapon_ball", [736523883] = "weapon_smg", [-209057321] = "weapon_golfball", [324215364] = "weapon_microsmg", [-1568386805] = "weapon_grenadelauncher", [741814745] = "weapon_stickybomb", [-1466123874] = "weapon_musket", [940833800] = "weapon_stone_hatchet", [2138347493] = "weapon_firework", [911657153] = "weapon_stungun", [-275439685] = "weapon_dbshotgun", [883325847] = "weapon_petrolcan", [101631238] = "weapon_fireextinguisher", [1198879012] = "weapon_flaregun", [487013001] = "weapon_pumpshotgun", [-581044007] = "weapon_machete", [-1813897027] = "weapon_grenade", [137902532] = "weapon_vintagepistol", [-1853920116] = "weapon_navyrevolver" }
Zen.Counter = { ['Hour'] = 3600, ['Day'] = 86400, ['Week'] = 604800, ['Month'] = 2592000, ['Year'] = 31536000 }

exports('getJobs', function() return Zen.Jobs end)
exports('getItems', function() return Zen.Items end)
exports('getAccounts', function() return Zen.Accounts end)