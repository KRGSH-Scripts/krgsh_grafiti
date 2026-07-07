ESX = nil
QBCore = nil

Citizen.CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
    end
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

RegisterNetEvent('graffiti_tags:save', function(data)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    
    MySQL:insert('INSERT INTO graffiti_tags (x, y, z, heading, image_url, creator) VALUES (?, ?, ?, ?, ?, ?)', {
        data.x,
        data.y,
        data.z,
        data.heading or 0.0,
        data.image_url,
        identifier
    }, function(id)
        if id then
            data.id = id
            TriggerClientEvent('graffiti_tags:created', -1, data)
        end
    end)
end)

RegisterNetEvent('graffiti_tags:takeMaterial', function(material)
    local src = source
    local player = nil
    
    if ESX then
        player = ESX.GetPlayerFromId(src)
        if player then
            local item = player.getInventoryItem(material)
            if item and item.count > 0 then
                player.removeInventoryItem(material, 1)
            end
        end
    elseif QBCore then
        player = QBCore.Functions.GetPlayer(src)
        if player then
            local item = player.Functions.GetItemByName(material)
            if item then
                player.Functions.RemoveItem(material, 1)
            end
        end
    end
end)

RegisterNetEvent('graffiti_tags:request', function()
    local src = source
    MySQL:rawExecute('SELECT * FROM graffiti_tags', {}, function(tags)
        TriggerClientEvent('graffiti_tags:load', src, tags)
    end)
end)

RegisterNetEvent('graffiti_tags:remove', function(tagId)
    local src = source
    
    MySQL:execute('DELETE FROM graffiti_tags WHERE id = ?', { tagId }, function(rows)
        if rows.affectedRows > 0 then
            TriggerClientEvent('graffiti_tags:removed', -1, tagId)
        end
    end)
end)

RegisterNetEvent('graffiti_tags:takeRemoveMaterial', function()
    local src = source
    local player = nil
    
    if ESX then
        player = ESX.GetPlayerFromId(src)
        if player then
            local item = player.getInventoryItem(Config.Removal.Material)
            if item and item.count > 0 then
                player.removeInventoryItem(Config.Removal.Material, 1)
            end
        end
    elseif QBCore then
        player = QBCore.Functions.GetPlayer(src)
        if player then
            local item = player.Functions.GetItemByName(Config.Removal.Material)
            if item then
                player.Functions.RemoveItem(Config.Removal.Material, 1)
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        MySQL:execute([[
            CREATE TABLE IF NOT EXISTS graffiti_tags (
                id INT AUTO_INCREMENT PRIMARY KEY,
                x FLOAT,
                y FLOAT,
                z FLOAT,
                heading FLOAT,
                image_url VARCHAR(255),
                creator VARCHAR(50),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ]])
    end
end)

exports('PlaceGraffiti', function(src, typeName)
    TriggerClientEvent('graffiti_tags:place', src, typeName)
end)