ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/archipelago.lua")

Tracker:AddItems("items/items.json")
Tracker:AddItems("items/entrance_items.json")

Tracker:AddMaps("maps/maps.json")

Tracker:AddLocations("locations/locations.json")

Tracker:AddLayouts("layouts/tracker.json")
-- Tracker:AddLayouts("layouts/settings.json")

ScriptHost:LoadScript("scripts/entrances.lua")

Entrances:Init()
