Framework = {}

function Framework.GetPlayerFromId(src)
    if GetResourceState('es_extended') == 'started' then
        return ESX.GetPlayerFromId(src)
    elseif GetResourceState('qb-core') == 'started' then
        return QBCore.Functions.GetPlayer(src)
    elseif GetResourceState('qbx_core') == 'started' then
        return exports.qbx_core:GetPlayer(src)
    else
        return {identifier = 'license:unknown', source = src}
    end
end

function Framework.GetPlayerIdentifier(xPlayer)
    if GetResourceState('es_extended') == 'started' then
        return xPlayer.identifier
    elseif GetResourceState('qb-core') == 'started' then
        return xPlayer.PlayerData.license
    elseif GetResourceState('qbx_core') == 'started' then
        return xPlayer.license
    else
        return 'license:unknown'
    end
end

function Framework.HasItem(xPlayer, item, amount)
    amount = amount or 1
    if GetResourceState('es_extended') == 'started' then
        local inventory = xPlayer.getInventoryItem(item)
        return inventory and inventory.count >= amount
    elseif GetResourceState('qb-core') == 'started' then
        local inventory = xPlayer.Functions.GetItemByName(item)
        return inventory and inventory.amount >= amount
    elseif GetResourceState('qbx_core') == 'started' then
        return xPlayer.hasItem(item, amount)
    else
        return true
    end
end

function Framework.RemoveItem(xPlayer, item, amount)
    amount = amount or 1
    if GetResourceState('es_extended') == 'started' then
        xPlayer.removeInventoryItem(item, amount)
    elseif GetResourceState('qb-core') == 'started' then
        xPlayer.Functions.RemoveItem(item, amount)
    elseif GetResourceState('qbx_core') == 'started' then
        exports.qbx_core:removeItem(xPlayer, item, amount)
    end
end