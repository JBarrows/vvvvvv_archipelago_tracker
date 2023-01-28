ScriptHost:LoadScript("scripts/item_mapping.lua")
ScriptHost:LoadScript("scripts/location_mapping.lua")

CUR_INDEX = -1

function ClearItem(code, type)
    if not code or not type then  return  end

    local item = Tracker:FindObjectForCode(code)
    if type == "toggle" then
        item.Active = false
    elseif type == "consumable" then
        item.AcquiredCount = 0
    end
end

function ClearLocation(name)
    if not name then  return  end

    local section = Tracker:FindObjectForCode(name)
    section.AvailableChestCount = section.ChestCount
end

function ClearItems(slot_data)
    CUR_INDEX = -1
    for _, v in pairs(ITEM_MAPPING) do
        ClearItem(v[1], v[2])
    end
end

function ClearLocations(slot_data)
    for _, v in pairs(LOCATION_MAPPING) do
        ClearLocation(v[1])
    end
end

function ClearOptions(slot_data)
    -- "DoorCost"
    if slot_data['DoorCost'] then
        local item = Tracker:FindObjectForCode("doorCost")
        item.AcquiredCount = slot_data['DoorCost']
    end

    -- "AreaCostRandomizer"
    -- "AreaRandomizer"
end

Archipelago:AddClearHandler("clearItems", ClearItems)
Archipelago:AddClearHandler("clearLocations", ClearLocations)
Archipelago:AddClearHandler("clearOptions", ClearOptions)

function GotItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    else
        CUR_INDEX = index
    end

    local v = ITEM_MAPPING[item_id]
    if not (v and v[1]) then  return  end

    local item = Tracker:FindObjectForCode(v[1])
    if (not v[2]) or v[2] == "toggle" then
        item.Active = true
    end
end

Archipelago:AddItemHandler("Item Handler", GotItem)

function GotLocation(location_id, location_name)
    local v = LOCATION_MAPPING[location_id]
    local sectionName = v[1]
    if not (v and sectionName) then  return  end

    local location = Tracker:FindObjectForCode(sectionName)
    if not location then  return  end

    location.AvailableChestCount = location.AvailableChestCount - 1
end

Archipelago:AddLocationHandler("Location Handler", GotLocation)