-- returns true if the key items mapped from the given list of numbers are all unlocked
-- eg. if codes = [1,2] then returns true if trinket 1 and trinket 2 are unlocked/active
function TrinketsUnlocked(codes)
    for _,v in ipairs(codes) do
        local count = Tracker:ProviderCountForCode("trinket" .. v)
        if count < 1 then
            return false
        end
    end
    
    return true
end

-- Returns the number of keys (count) needed to open any door
-- To get the exact numerical identifiers matched to a specific door, use GetKeys and TrinketsUnlocked
function DoorCost()
    return Tracker:ProviderCountForCode("doorCost")
end

-- Returns true if doors are always unlocked, as in the base game
function FreeDoors()
    return DoorCost() <= 0
end

-- Returns a list of numbers (1-12) that map to required keys for the given price index (0-3)
-- Ranges will be dependant on DoorCost.
-- In this case keys are shiny trinkets
-- index: keys(by cost)
-- 0: 1, 1-2, 1-3
-- 1: 2, 3-4, 4-6
-- 2: 3, 5-6, 7-9
-- 3: 4, 7-8, 10-12
function GetKeys(index)
    local dc = DoorCost()
    local offset = (index * dc)
    local keys = { }
    for i=1, dc do
        keys[i] = offset + i
    end

    return keys
end

-- Returns true if the region for a given index is accessible
function DestinationUnlocked(...)
    if FreeDoors() or select("#",...) == 0 then return true end

    for _, index in ipairs({...}) do
        local destIdx = tonumber(index)

        -- If areas are shuffled, find out which door leads to the target region (if any)
        -- Consider: "Door 1" might lead to "Room 3"
        local doorIndex = Entrances:DoorIndexForDestination(destIdx)
        if not doorIndex then return false end -- There may not be a destination assigned to this entrance

        -- If area costs are shuffled, we need find out which set of keys we're looking for
        -- Consider: "Key Ring 2" might be needed to unlock "Door 1"
        local priceIndex = Entrances:PriceIndexForDoor(doorIndex)

        -- Finally, we check if we have each every key in the price
        -- The metaphor is a bit stretched, but let's say that "Key Ring 2" needs keys 7, 8, AND 9 to unlock the door
        local keysUnlocked = TrinketsUnlocked(GetKeys(priceIndex))
        if not keysUnlocked then
            return false -- EXIT: Return immediately if even one key isn't collected
        end
    end

    return true
end
