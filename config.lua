-- Config.lua

Config = {}

-- Position des Melders
Config.melderPosition = { x = 0.85, y = 0.95 }

-- Größe des Melders
Config.melderSize = { width = 250, height = 300 }

-- Position der Knöpfe
Config.buttonPositions = {
    { x = 0.5, y = 0.6 }, -- Knopf 1
    { x = 0.5, y = 0.7 }, -- Knopf 2
    { x = 0.5, y = 0.8 }, -- Knopf 3
    { x = 0.5, y = 0.9 }, -- Knopf 4
}

-- Größe des Displays
Config.displaySize = { width = 200, height = 50 }

-- Position des Displays
Config.displayPosition = { x = 0.5, y = 0.4 }

-- Tastenbindung für den Funkmelder
Config.buttonBinding = {
    accept = 69, -- Taste "E"
    decline = 81, -- Taste "Q"
    toggle = 79, -- Taste "O"
    lastEinsatz = 85 -- Taste "U"
}