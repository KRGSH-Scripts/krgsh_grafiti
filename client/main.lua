local tags = {}
local activeTags = {}
local placingTag = false
local placingType = nil
local placingEntity = nil
local progressActive = false

local function GetTargetExport()
    if GetResourceState('ox_target') == 'started' then
        return exports.ox_target
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']
    end
    return nil
end

function LoadTags(tagList)
    tags = tagList or {}
    for _, tag in ipairs(tags) do
        CreateTagDUI(tag)
    end
end

function CreateTagDUI(tag)
    local url = 'nui://graffiti_tags/html/graffiti.html?url=' .. tag.image_url
    local dui = CreateDui(url, 512, 512)
    local txd = CreateRuntimeTxd('graffiti_txd_' .. tag.id)
    local dxt = CreateRuntimeTextureFromDui(txd, 'graffiti_tex_' .. tag.id, 512, 512)
    
    activeTags[tag.id] = {
        id = tag.id,
        dui = dui,
        entity = nil,
        textureDict = 'graffiti_txd_' .. tag.id,
        textureName = 'graffiti_tex_' .. tag.id,
        x = tag.x,
        y = tag.y,
        z = tag.z,
        heading = tag.heading or 0.0,
        image = tag.image_url
    }
    
    SetDuiUrl(dui, url)
end

function DrawTag3D(tag)
    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(tag.x, tag.y, tag.z + 1.0)
    
    if onScreen then
        SetDrawOrigin(tag.x, tag.y, tag.z + 1.0, false)
        DrawSprite(tag.textureDict, tag.textureName, 0.0, 0.0, 2.0, 2.0, tag.heading, 255, 255, 255, 255)
        ClearDrawOrigin()
    end
end

function StartSprayAnim()
    local ped = PlayerPedId()
    local animDict = Config.Placing.Animation.dict
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, animDict, Config.Placing.Animation.name, 8.0, -8.0, -1, Config.Placing.Animation.flag, 0, false, false, false)
    
    placingEntity = CreateObjectNoOffset(GetHashKey(Config.Placing.Prop), 0.0, 0.0, 0.0, false, false, false)
    AttachEntityToEntity(placingEntity, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, true, true, false, true, 1, true)
end

function StopSprayAnim()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    if placingEntity then
        DeleteEntity(placingEntity)
        placingEntity = nil
    end
end

function StartRemoveAnim()
    local ped = PlayerPedId()
    local animDict = Config.Removal.Animation.dict
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, animDict, Config.Removal.Animation.name, 8.0, -8.0, -1, Config.Removal.Animation.flag, 0, false, false, false)
    
    placingEntity = CreateObjectNoOffset(GetHashKey(Config.Removal.Prop), 0.0, 0.0, 0.0, false, false, false)
    AttachEntityToEntity(placingEntity, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, true, true, false, true, 1, true)
end

function StopRemoveAnim()
    StopSprayAnim()
end

function ShowProgress(duration, label, onFinish, onCancel)
    progressActive = true
    SendNUIMessage({ action = 'progress', duration = duration, label = label })
    
    Citizen.CreateThread(function()
        local endTime = GetGameTimer() + duration
        while progressActive and GetGameTimer() < endTime do
            Wait(0)
            DisableControlAction(0, 202, true)
            if IsControlJustPressed(0, 202) then
                progressActive = false
                onCancel()
                return
            end
        end
        if progressActive then
            progressActive = false
            onFinish()
        end
    end)
end

function PlaceGraffiti(typeName)
    local graffitiType = nil
    for _, t in ipairs(Config.GraffitiTypes) do
        if t.name == typeName then
            graffitiType = t
            break
        end
    end
    
    if not graffitiType then return end
    
    placingTag = true
    placingType = graffitiType
    
    StartSprayAnim()
    
    ShowProgress(Config.Placing.Duration, 'Placing Graffiti...', function()
        StopSprayAnim()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        
        local rayHandle = StartShapeTestRay(
            coords.x, coords.y, coords.z,
            coords.x + GetEntityForwardVector(ped).x * 2.0,
            coords.y + GetEntityForwardVector(ped).y * 2.0,
            coords.z + GetEntityForwardVector(ped).z * 2.0,
            -1, ped, 0
        )
        
        local _, hit, hitCoords = GetShapeTestResult(rayHandle)
        local placeCoords = hit and hitCoords or coords
        
        TriggerServerEvent('graffiti_tags:save', {
            x = placeCoords.x,
            y = placeCoords.y,
            z = placeCoords.z,
            heading = heading,
            image_url = graffitiType.image
        })
        
        TriggerServerEvent('graffiti_tags:takeMaterial', graffitiType.material)
        placingTag = false
    end, function()
        StopSprayAnim()
        placingTag = false
    end)
end

function StartRemoveGraffiti(tagId)
    if not tagId or not activeTags[tagId] then return end
    
    TriggerServerEvent('graffiti_tags:checkRemoveMaterial')
    
    StartRemoveAnim()
    
    ShowProgress(Config.Removal.Duration, 'Removing Graffiti...', function()
        StopRemoveAnim()
        TriggerServerEvent('graffiti_tags:remove', tagId)
    end, function()
        StopRemoveAnim()
    end)
end

RegisterNetEvent('graffiti_tags:load', function(tagList)
    LoadTags(tagList)
end)

RegisterNetEvent('graffiti_tags:created', function(data)
    CreateTagDUI(data)
end)

RegisterNetEvent('graffiti_tags:removed', function(id)
    if activeTags[id] and activeTags[id].dui then
        DestroyDui(activeTags[id].dui)
        activeTags[id] = nil
    end
end)

RegisterCommand('graffiti', function(source, args)
    local typeName = args[1] or 'tag1'
    PlaceGraffiti(typeName)
end, false)

RegisterCommand('graffiti_remove', function(source, args)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    
    for id, tag in pairs(activeTags) do
        local dist = #(vector3(playerPos.x, playerPos.y, playerPos.z) - vector3(tag.x, tag.y, tag.z))
        if dist < 3.0 then
            StartRemoveGraffiti(id)
            break
        end
    end
end, false)

Citizen.CreateThread(function()
    Wait(5000)
    TriggerServerEvent('graffiti_tags:request')
    
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        
        for id, tag in pairs(activeTags) do
            local distance = #(vector3(playerPos.x, playerPos.y, playerPos.z) - vector3(tag.x, tag.y, tag.z))
            
            if distance <= Config.Usage.DrawDistance and distance >= Config.Usage.Range then
                DrawTag3D(tag)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function()
    for id, tag in pairs(activeTags) do
        if tag.dui then
            DestroyDui(tag.dui)
        end
    end
    StopSprayAnim()
end)

AddEventHandler('onResourceStart', function()
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalObject({
            {
                name = 'graffiti_remove',
                icon = 'fas fa-spray-can',
                label = 'Remove Graffiti',
                event = 'graffiti_tags:removeTarget',
                args = {},
                canInteract = function(entity)
                    return true
                end
            }
        })
    end
end)