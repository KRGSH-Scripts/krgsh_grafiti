-- Item Usage Tests for Graffiti Tags

package.path = package.path .. ';../shared/?.lua'

local function testMaterialConfig()
    print("Testing material configuration...")
    
    dofile('shared/config.lua')
    
    local materials = Config.Placing.Materials
    assert(type(materials) == 'table', "Materials should be a table")
    assert(materials.spray_can ~= nil, "spray_can should be configured")
    assert(materials.required_amount ~= nil, "required_amount should be set")
    
    print(string.format("  ✓ Required material: %s", materials.spray_can or "none"))
    print(string.format("  ✓ Required amount: %d", materials.required_amount or 0))
end

local function testGraffitiTypesMaterials()
    print("\nTesting graffiti types have materials...")
    
    dofile('shared/config.lua')
    
    for i, tag in ipairs(Config.GraffitiTypes) do
        assert(type(tag) == 'table', "Tag type " .. i .. " should be table")
        assert(tag.material ~= nil, "Tag " .. tag.name .. " should have material")
        print(string.format("  ✓ Tag '%s' requires: %s", tag.name, tag.material))
    end
end

local function testItemRequirementLogic()
    print("\nTesting item requirement logic (mock)...")
    
    dofile('shared/config.lua')
    
    -- Mock player states
    local playerWithItem = { inventory = { spray_can = 3 } }
    local playerWithoutItem = { inventory = { spray_can = 0 } }
    
    local function hasEnough(player, item, amount)
        return player.inventory[item] >= (amount or 1)
    end
    
    local required = Config.Placing.Materials.required_amount
    
    assert(hasEnough(playerWithItem, 'spray_can', required), "Should have enough spray cans")
    assert(not hasEnough(playerWithoutItem, 'spray_can', required), "Should not have enough spray cans")
    
    print("  ✓ Player with spray_can: OK")
    print("  ✓ Player without spray_can: Blocks usage")
end

-- Run tests
testMaterialConfig()
testGraffitiTypesMaterials()
testItemRequirementLogic()
print("\nAll item tests passed!")