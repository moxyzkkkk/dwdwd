Zen.Config.PiggyBack = {
    Cooldown = 3,
    
    Animations = {
        { -- source
            dict = 'anim@arena@celeb@flat@paired@no_props@',
            anim = 'piggyback_c_player_a',
            flag = 49
        },
        { -- target
            dict = 'anim@arena@celeb@flat@paired@no_props@',
            anim = 'piggyback_c_player_b',
            attach = vec3(0.0, -0.07, 0.45),
            flag = 33
        }
    }
}