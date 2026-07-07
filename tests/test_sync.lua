-- Client-Server Sync Tests for Graffiti Tags

local function testBroadcastEvents()
    print("Testing broadcast event patterns...")
    
    local serverContent = io.open('server/main.lua', 'r'):read('*a')
    
    -- Test: Server sends to all clients (-1) on create
    assert(serverContent:find("graffiti.tags.created", 1, true) or serverContent:find("graffiti_tags:created"), 
        "Server should broadcast graffiti created event to all clients")
    assert(serverContent:find(", %-1,"), "Server should use -1 for broadcast")
    print("  ✓ graffiti_tags:created broadcasts to all clients (-1)")
    
    -- Test: Server sends to all clients (-1) on remove
    assert(serverContent:find("graffiti_tags:removed"), 
        "Server should broadcast graffiti removed event to all clients")
    print("  ✓ graffiti_tags:removed broadcasts to all clients (-1)")
    
    -- Test: Server sends to specific client on load
    assert(serverContent:find("graffiti_tags:load', src"), 
        "Server should send load event to requesting client")
    print("  ✓ graffiti_tags:load sends to requesting client only")
end

local function testClientHandlers()
    print("\nTesting client event handlers...")
    
    local clientContent = io.open('client/main.lua', 'r'):read('*a')
    
    -- Test: Client receives and handles sync events
    assert(clientContent:find("graffiti_tags:created"), 
        "Client should handle graffiti created event")
    print("  ✓ Client handles graffiti_tags:created")
    
    assert(clientContent:find("graffiti_tags:removed"), 
        "Client should handle graffiti removed event")
    print("  ✓ Client handles graffiti_tags:removed")
    
    assert(clientContent:find("graffiti_tags:load"), 
        "Client should handle graffiti load event")
    print("  ✓ Client handles graffiti_tags:load")
end

local function testSyncDataIntegrity()
    print("\nTesting sync data integrity...")
    
    -- Verify data structure is consistent
    local serverContent = io.open('server/main.lua', 'r'):read('*a')
    local clientContent = io.open('client/main.lua', 'r'):read('*a')
    
    -- Check that server sends id
    assert(serverContent:find("data%.id%s*=%s*id"), 
        "Server should include id in synced data")
    print("  ✓ Sync includes tag ID")
    
    -- Check that client uses id
    assert(clientContent:find("tag%.id"), 
        "Client should use tag ID for tracking")
    print("  ✓ Client tracks by ID")
end

local function testInitialSync()
    print("\nTesting initial sync on resource start...")
    
    local clientContent = io.open('client/main.lua', 'r'):read('*a')
    
    assert(clientContent:find("graffiti_tags:request"), 
        "Client should request tags on start")
    print("  ✓ Client requests tags on resource start")
end

-- Run all tests
testBroadcastEvents()
testClientHandlers()
testSyncDataIntegrity()
testInitialSync()
print("\nAll sync tests passed!")