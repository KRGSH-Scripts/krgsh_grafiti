-- Simple test runner for FiveM Lua (no external dependencies)

local function assertEquals(expected, actual, msg)
    if expected ~= actual then
        print("FAIL: " .. tostring(msg) .. " - expected: " .. tostring(expected) .. ", got: " .. tostring(actual))
        return false
    end
    return true
end

local function assertTrue(condition, msg)
    if not condition then
        print("FAIL: " .. tostring(msg))
        return false
    end
    return true
end

local function runTest(name, testFunc)
    local success, err = pcall(testFunc)
    if success then
        print("PASS: " .. name)
        return true
    else
        print("FAIL: " .. name .. " - " .. tostring(err))
        return false
    end
end

-- Run tests
print("Running config tests...")

runTest("Config exists", function()
    local config = dofile('shared/config.lua')
    assertTrue(type(Config) == 'table', "Config should be a table")
end)

runTest("Usage config", function()
    local config = dofile('shared/config.lua')
    assertTrue(type(Config.Usage.Range) == 'number', "Range should be number")
    assertTrue(type(Config.Usage.DrawDistance) == 'number', "DrawDistance should be number")
end)

runTest("Placing config", function()
    local config = dofile('shared/config.lua')
    assertTrue(type(Config.Placing.Duration) == 'number', "Duration should be number")
    assertTrue(type(Config.Placing.Animation) == 'table', "Animation should be table")
end)

runTest("Graffiti types exist", function()
    local config = dofile('shared/config.lua')
    assertTrue(type(Config.GraffitiTypes) == 'table', "GraffitiTypes should be table")
end)

print("All tests complete!")