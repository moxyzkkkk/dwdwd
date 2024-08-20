Zen.Config.Drugs = {
    Weed = { --
        Name = 'Weed',
        Locations = {
            Collect = {
                Coords = vec3(1057.56,-3197.6, -39.13),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'weed',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(-255.88, -1542.88, 31.91),
                    Color = 2,
                    Type = 140,
                    Name = '~p~Drug~w~ | Weed Collect'
                },
            },
            Process = {
                Coords = vec3(1036.45, -3204.05, -38.17),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'weed_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'weed',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(1036.45, -3204.05, -38.17),
                    Color = 2,
                    Type = 496,
                    Name = '~p~Drug~w~ | Weed Process'
                },
            },
            Sell = {
                Coords = vec3(392.6434, -831.7905, 29.2917),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 35000
                    },
                    Need = {
                        Name = 'weed_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(392.6434, -831.7905, 29.2917),
                    Color = 2,
                    Type = 140,
                    Name = '~p~Drug~w~ | Weed Sell'
                },
            },
        },
    },

    Fentanyl = { -- HIDDEN
        Name = 'Fentanyl',
        Locations = {
            Collect = {
                Coords = vec3(-1110.45, -1635.03, 4.61),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'fentanyl',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(-1110.45, -1635.03, 4.61),
                    Color = 22,
                    Type = 256,
                    Name = '~p~Drug~w~ | Fentanyl Collect'
                },
            },
            Process = {
                Coords = vec3(-1129.57, -1604.72, 4.39),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'fentanyl_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'fentanyl',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(-1129.57, -1604.72, 4.39),
                    Color = 22,
                    Type = 256,
                    Name = '~p~Drug~w~ | Fentanyl Process'
                },
            },
            Sell = {
                Coords = vec3(-1361.05, -932.12, 9.7),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 100000
                    },
                    Need = {
                        Name = 'fentanyl_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(-1361.05, -932.12, 9.7),
                    Color = 22,
                    Type = 256,
                    Name = '~p~Drug~w~ | Fentanyl Sell'
                },
            },
        },
    },

    Xanax = { -- HIDDEN
        Name = 'Xanax',
        Locations = {
            Collect = {
                Coords = vec3(718.82, -767.64, 24.88),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'xanax',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(718.82, -767.64, 24.88),
                    Color = 22,
                    Type = 256,
                    Name = '~p~Drug~w~ | Xanax Collect'
                },
            },
            Process = {
                Coords = vec3(713.97, -716.53, 26.19),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'xanax_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'xanax',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(713.97, -716.53, 26.19),
                    Color = 2,
                    Type = 496,
                    Name = '~p~Drug~w~ | Xanax Process'
                },
            },
            Sell = {
                Coords = vec3(748.66, -529.0, 27.77),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 115000
                    },
                    Need = {
                        Name = 'xanax_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(748.66, -529.0, 27.77),
                    Color = 2,
                    Type = 140,
                    Name = '~p~Drug~w~ | Xanax Sell'
                },
            },
        },
    },

    Opium = {
        Name = 'Opium',
        Locations = {
            Collect = {
                Coords = vec3(-225.6320, -2655.2388, 6.0003),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'opium',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(-225.6320, -2655.2388, 6.0003),
                    Color = 1,
                    Type = 303,
                    Name = '~p~Drug~w~ | Opium Collect'
                },
            },
            Process = {
                Coords = vec3(-232.6687, -2653.1587, 6.0003),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'opium_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'opium',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(-232.6687, -2653.1587, 6.0003),
                    Color = 1,
                    Type = 303,
                    Name = '~p~Drug~w~ | Opium Process'
                },
            },
            Sell = {
                Coords = vec3(343.7403, -2027.9097, 22.3535),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 85000
                    },
                    Need = {
                        Name = 'opium_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(343.7403, -2027.9097, 22.3535),
                    Color = 1,
                    Type = 303,
                    Name = '~p~Drug~w~ | Opium Sell'
                },
            },
        },
    },

    Meth = { --
        Name = 'Meth',
        Locations = {
            Collect = {
                Coords = vec3(1005.7565, -3200.3079, -38.5205),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'meth',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(319.43, -176.57, 58.12),
                    Color = 55,
                    Type = 499,
                    Name = '~p~Drug~w~ | Meth Collect'
                },
            },
            Process = {
                Coords = vec3(1014.8652, -3194.9563, -38.9932),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'meth_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'meth',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(1014.8652, -3194.9563, -38.9932),
                    Color = 55,
                    Type = 499,
                    Name = '~p~Drug~w~ | Meth Process'
                },
            },
            Sell = {
                Coords = vec3(vec3(947.75, -1570.11, 30.53)),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 55000
                    },
                    Need = {
                        Name = 'meth_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(vec3(947.75, -1570.11, 30.53)),
                    Color = 55,
                    Type = 499,
                    Name = '~p~Drug~w~ | Meth Sell'
                },
            },
        },
    },

    Cocaine = { --
        Name = 'Cocaine', 
        Locations = {
            Collect = {
                Coords = vec3(1094.1396, -3196.6709, -38.9935),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'cocaine',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(132.94, 96.42, 83.5),
                    Color = 26,
                    Type = 514,
                    Name = '~p~Drug~w~ | Cocaine Collect'
                },
            },
            Process = {
                Coords = vec3(1099.6237, -3194.5132, -38.9935),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'cocaine_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'cocaine',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(1099.6237, -3194.5132, -38.9935),
                    Color = 26,
                    Type = 514,
                    Name = '~p~Drug~w~ | Cocaine Process'
                },
            },
            Sell = {
                Coords = vec3(-783.76, -391.04, 37.33),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 60000
                    },
                    Need = {
                        Name = 'cocaine_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(-783.76, -391.04, 37.33),
                    Color = 26,
                    Type = 514,
                    Name = '~p~Drug~w~ | Cocaine Sell'
                },
            },
        },
    },

    Codiene = { --
        Name = 'Codiene',
        Locations = {
            Collect = {
                Coords = vec3(845.02, -2364.95, 30.34),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'codiene',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(845.02, -2364.95, 30.34),
                    Color = 27,
                    Type = 468,
                    Name = '~p~Drug~w~ | Codiene Collect'
                },
            },
            Process = {
                Coords = vec3(839.62, -2315.0, 30.48),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'codiene_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'codiene',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(839.62, -2315.0, 30.48),
                    Color = 27,
                    Type = 468,
                    Name = '~p~Drug~w~ | Codiene Process'
                },
            },
            Sell = {
                Coords = vec3(1165.84, -1347.27, 35.74),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 70000
                    },
                    Need = {
                        Name = 'codiene_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(1165.84, -1347.27, 35.74),
                    Color = 27,
                    Type = 468,
                    Name = '~p~Drug~w~ | Codiene Sell'
                },
            },
        },
    },

    Percocet = {
        Name = 'Percocet',
        Locations = {
            Collect = {
                Coords = vec3(1977.79, 3819.48, 33.45),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'percocet',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(1977.79, 3819.48, 33.45),
                    Color = 70,
                    Type = 51,
                    Name = '~p~Drug~w~ | Percocet Collect'
                },
            },
            Process = {
                Coords = vec3(1965.19, 3819.82, 32.39),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'percocet_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'percocet',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(1965.19, 3819.82, 32.39),
                    Color = 70,
                    Type = 51,
                    Name = '~p~Drug~w~ | Percocet Process'
                },
            },
            Sell = {
                Coords = vec3(1407.97, 3619.29, 34.89),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 95000
                    },
                    Need = {
                        Name = 'percocet_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(1407.97, 3619.29, 34.89),
                    Color = 70,
                    Type = 51,
                    Name = '~p~Drug~w~ | Percocet Sell'
                },
            },
        },
    },

    Lean = { --
        Name = 'Lean',
        Locations = {
            Collect = {
                Coords = vec3(-103.39, 6193.5, 31.02),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'lean',
                        Amount = 1
                    },
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(-103.39, 6193.5, 31.02),
                    Color = 27,
                    Type = 77,
                    Name = '~p~Drug~w~ | Lean Collect'
                },
            },
            Process = {
                Coords = vec3(-132.95, 6165.19, 31.02),
                Radius = 3.0,
                Time = 3,
                Items = {
                    Reward = {
                        Name = 'lean_pouch',
                        Amount = 1
                    },
                    Need = {
                        Name = 'lean',
                        Amount = 10
                    }
                },
                Blip = {
                    Enabled = false,
                    Coords = vec3(-132.95, 6165.19, 31.02),
                    Color = 27,
                    Type = 77,
                    Name = '~p~Drug~w~ | Lean Process'
                },
            },
            Sell = {
                Coords = vec3(110.32, 6630.53, 31.78),
                Radius = 3.0,
                Time = 3,
                Items = {
                    SellReward = {
                        Amount = 75000
                    },
                    Need = {
                        Name = 'lean_pouch',
                        Amount = 1
                    }
                },
                Blip = {
                    Enabled = true,
                    Coords = vec3(110.32, 6630.53, 31.78),
                    Color = 27,
                    Type = 77,
                    Name = '~p~Drug~w~ | Lean Sell'
                },
            },
        },
    }
}