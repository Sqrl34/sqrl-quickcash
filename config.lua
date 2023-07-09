Config = Config or {}

Config.Cooldown = 1 -- In minutes

Config.Blip = {
    location = vector3(1108.06, 58.72, 79.76),
    scale = .6,
    color = 15, -- See for refrence https://docs.fivem.net/docs/game-references/blips/
    sprite = 326, -- See for refrence https://docs.fivem.net/docs/game-references/blips/
    name = "Test Blip"
}

Config.StarterPedInfo = {
    model = `a_m_m_indian_01`, -- https://docs.fivem.net/docs/game-references/ped-models/
    coords = vector4(1108.06, 58.72, 79.76, 232.27), -- Make sure the Z coordinate is -1 than the original if changing

}

Config.Locations = {
    -- Coke 
    [1] = {
        Item = "cokebaggy2", -- Item name within your shared items folder
        Amount = 2, -- Amount of items given to the player to transfer between areas
        Reward = { -- Make sure item, bank, and cash only have 1 true value between either one of them
            Item = {
                item = true,
                name = 'markedbills', -- item given as a reward if item is true
                amount = 3 -- Amount of items given to player as reward
            },
            Money = { -- Decide which account money will go into and the amount that will be given
                bank = true,
                cash = true,
                amount = 10000
            }
        },
        Blip = {
            coords = vector3(801.06, -726.88, 27.78), -- Location of Blip
            color = 16, -- See for refrence https://docs.fivem.net/docs/game-references/blips/
            sprite = 514, -- See for refrence https://docs.fivem.net/docs/game-references/blips/
            name = "Coke Pickup"  -- Name of blip on map
        },
        Prop = {
            model = 'hei_prop_heist_weed_block_01', -- Ability to change at https://forge.plebmasters.de/objects
            coords = vector3(800.75, -726.12, 26.82) -- Location, make sure the Z coord is -1 than original
        },
        Messages = { -- Messages that Oswald will send during the course of the mission
            Pickup = "Go pickup the coke brick(s) from the given location",
            Drop = "Go drop off the coke brick(s) at the given location",
            Completed = "Excelent work, come see me again soon for more work"
        }
    },
    -- Ammo
    [2] = {
        Item = "ammo_box",
        Amount = 2,
        Reward = {
            Item = {
                item = true,
                name = 'markedbills',
                amount = 3
            },
            Money = {
                bank = true,
                cash = true,
                amount = 10000
            }
        },
        Blip = {
            coords = vector3(-261.94, -903.1, 32.31),
            color = 16,
            sprite = 150,
            name = "Ammo Pickup"
        },
        Prop = {
            model = 'prop_box_ammo03a',
            coords = vector3(-261.94, -903.1, 31.31)
        },
        Messages = {
            Pickup = "Go pickup the ammo box(es) from the given location",
            Drop = "Go drop off the  ammo box(es) at the given location",
            Completed = "Excelent work, come see me again soon for more work"
        }
    },
    -- Weed
    [3] = {
        Item = "weed_brick2",
        Amount = 2,
        Reward = {
            Item = {
                item = true,
                name = 'markedbills',
                amount = 3
            },
            Money = {
                bank = true,
                cash = true,
                amount = 10000
            }
        },
        Blip = {
            coords = vector3(-3226.18, 1096.84, 10.61),
            color = 16,
            sprite = 469,
            name = "Weed Pickup"
        },
        Prop = {
            model = 'prop_drug_package',
            coords = vector3(-3226.18, 1096.84, 9.61)
        },
        Messages = {
            Pickup = "Go pickup the weed package(s) from the given location",
            Drop = "Go drop off the  weed package(s) at the given location",
            Completed = "Excelent work, come see me again soon for more work"
        }
    }


}

Config.DropOff = {
    Blip = {
        color = 66, -- See for refrence https://docs.fivem.net/docs/game-references/blips/
        sprite = 271, -- See for refrence https://docs.fivem.net/docs/game-references/blips/
        name = "Drop Off" -- Name of blip
    },
    Locations = { -- Locations which the player will drop off the items
        [1] = {
            coords = vector3(-1680.63, -291.25, 51.88),

        },
        [2] = {
            coords = vector3(-6.02, -203.52, 52.67),

        },
        [3] = {
            coords = vector3(144.08, -130.08, 54.83),

        }
    }
}
