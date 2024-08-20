PackageConfig = {
    blip = { sprite = 781, color = 27, scale = 0.8, text = "Turf Package Sells" },
    item ={
        name = "turf_package",
        reward = 7500,
    },
    normalRate = 3000,
    vipRate = 2500,
    premiumVipRate = 2000,
    zones = { vec3(-41.8477, 1882.5278, 195.7473) },
    animation = { scenario = "PROP_HUMAN_BUM_BIN" },
    ranks = {
        levels = {
            [1] = 5000,
            [2] = 10000,
            [3] = 15000,
            [4] = 20000,
            [5] = 30000,
            [6] = 40000
        },
        rewards = {
            [1] = 0.0,
            [2] = 0.1,
            [3] = 0.2,
            [4] = 0.3,
            [5] = 0.4,
            [6] = 0.5
        }
    }
}

KillZones = {
    blip = { sprite = 468, color = 0, scale = 0.75 },
    zones = {
        ['zone_id'] = {
            name = "Opium Zone",
            coords = vector4(-221.1765, -2625.9421, 6.0511, 120.00),
            money_per_kill = 2500,
            king_kills = 5,
            king_rewards = 50000,
            debug = false
        },
    },
}
