-- Visibility Tests for Graffiti Tags

package.path = package.path .. ';../shared/?.lua'

local min, max = math.min, math.max

local function testDistanceCheck()
    print("Testing distance visibility logic...")
    
    local playerPos = { x = 0.0, y = 0.0, z = 0.0 }
    local tagPos = { x = 20.0, y = 0.0, z = 0.0 }
    
    local function getDistance(p1, p2)
        return math.sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
    end
    
    -- Test 1: Tag außerhalb sichtbarer Distanz (zu nah)
    local closePos = { x = 10.0, y = 0.0, z = 0.0 }
    local closeDist = getDistance(playerPos, closePos)
    assert(closeDist < Config.Usage.Range, "CLOSE: Should be within range")
    print(string.format("  ✓ Close tag distance: %.1fm (below range %.1fm)", closeDist, Config.Usage.Range))
    
    -- Test 2: Tag in sichtbarem Bereich
    local visDist = getDistance(playerPos, tagPos)
    assert(visDist >= Config.Usage.Range and visDist <= Config.Usage.DrawDistance, 
        string.format("VISIBLE: %d >= %d and %d <= %d", visDist, Config.Usage.Range, visDist, Config.Usage.DrawDistance))
    print(string.format("  ✓ Visible tag distance: %.1fm (in range %.1f-%.1fm)", visDist, Config.Usage.Range, Config.Usage.DrawDistance))
    
    -- Test 3: Tag außerhalb Render-Distanz
    local farPos = { x = 30.0, y = 0.0, z = 0.0 }
    local farDist = getDistance(playerPos, farPos)
    assert(farDist > Config.Usage.DrawDistance, "FAR: Should be beyond draw distance")
    print(string.format("  ✓ Far tag distance: %.1fm (above draw distance %.1fm)", farDist, Config.Usage.DrawDistance))
    
    print("All visibility tests passed!")
end

local function testVisibilityBoundaries()
    print("\nTesting visibility boundaries...")
    
    local range = Config.Usage.Range
    local drawDist = Config.Usage.DrawDistance
    
    -- Ensure sensible values
    assert(range >= 1.0, "Range should be positive")
    assert(drawDist > range, "DrawDistance should be greater than Range")
    assert(drawDist <= 100.0, "DrawDistance should be reasonable")
    
    print(string.format("  ✓ Range: %.1fm, DrawDistance: %.1fm", range, drawDist))
    print(string.format("  ✓ Visible zone: %.1fm - %.1fm (width: %.1fm)", range, drawDist, drawDist - range))
end

-- Run tests
dofile('shared/config.lua')
testDistanceCheck()
testVisibilityBoundaries()