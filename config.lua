Config = {
    Locale = GetConvar('esx:locale', 'en'),

    MaxFrequency = 500,

    Item = 'Radio',

    OpenKey = 'CAPITAL', -- Caps Lock

    RestrictedChannels = {
        { -- Channel 1
            police = true
        },
        { -- Channel 2
            police = true
        },
        { -- Channel 3
            ambulance = true
        },
        { -- Channel 4
            ambulance = true
        },
        { -- Channel 5
            sheriff = true
        },
        { -- Channel 6
            sheriff = true
        },
        { -- Channel 7
            police = true,
            ambulance = true,
            sheriff = true
        }
    },
}