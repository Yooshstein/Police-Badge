local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('police_badge', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    local job = Player.PlayerData.job and Player.PlayerData.job.name or nil
    if job ~= 'police' then
        TriggerClientEvent('QBCore:Notify', source, 'Only police officers can use this.', 'error')
        return
    end

    TriggerClientEvent('trw:badgeUsed', source)
end)

RegisterNetEvent('trw:server:GiveKeys', function(plate)
    local src = source
    if not plate or plate == '' then return end
    TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    print(('[qb-police-badge] Gave keys to player %s for plate %s'):format(src, plate))
end)
