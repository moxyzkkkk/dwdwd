Zen.Config.TakeHostage = {
    AllowedWeapons = { 'weapon_pistol', 'weapon_combatpistol', 'weapon_appistol' },
    SearchEnabled = true,

    Animations = {
        { -- source
            animDict = "anim@gangops@hostage@",
            anim = "perp_idle",
            flag = 49,
        },
        { -- target
            animDict = "anim@gangops@hostage@",
            anim = "victim_idle",
            attach = vec3(-0.24, 0.11, 0.0),
            flag = 49,
        }
    }
}