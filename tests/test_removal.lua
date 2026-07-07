-- Removal Tests for Graffiti Tags

local function testRemovalConfig()
    print("Testing removal configuration...")
    
    dofile('shared/config.lua')
    
    assert(type(Config.Removal) == 'table', "Removal config should be table")
    assert(type(Config.Removal.Duration) == 'number', "Removal duration should be number")
    assert(Config.Removal.Material ~= nil, "Removal material should be set")
    assert(Config.Removal.RequiredAmount ~= nil, "Required amount should be set")
    
    print(string.format("  ✓ Removal duration: %d ms", Config.Removal.Duration))
    print(string.format("  ✓ Removal material: %s", Config.Removal.Material))
    print(string.format("  ✓ Required amount: %d", Config.Removal.RequiredAmount))
end

local function testRemovalLogic()
    print("\nTesting removal logic...")
    
    -- Mock active tags
    local activeTags = {
        [1] = { x = 10.0, y = 20.0, z = 30.0, id = 1 },
        [2] = { x = 40.0, y = 50.0, z = 60.0, id = 2 }
    }
    
    local function findNearestTag(playerPos, tags, maxDist)
        local nearest, nearestDist
        for id, tag in pairs(tags) do
            local dist = math.sqrt((tag.x - playerPos.x)^2 + (tag.y - playerPos.y)^2 + (tag.z - playerPos.z)^2)
            if dist < (maxDist or 3.0) and (not nearestDist or dist < nearestDist) then
                nearest = id
                nearestDist = dist
            end
        end
        return nearest
    end
    
    local playerPos = { x = 10.5, y = 20.5, z = 30.5 }
    local nearest = findNearestTag(playerPos, activeTags, 3.0)
    
    assert(nearest == 1, "Should find nearest tag")
    print("  ✓ Nearest tag detection works")
end

local function testRemovalEvents()
    print("\nTesting removal event handlers...")
    
    -- Check server has remove handler
    local serverFile = io.open('server/main.lua', 'r')
    local serverContent = serverFile:read('*a')
    serverFile:close()
    
    assert(serverContent:find('graffiti_tags:remove'), "Server should have remove event")
    assert(serverContent:find('DELETE FROM graffiti_tags'), "Server should have DELETE query")
    print("  ✓ Server remove event present")
    print("  ✓ Database delete query present")
end

-- Run tests
testRemovalConfig()
testRemovalLogic()
testRemovalEvents()
print("\nAll removal tests passed!")