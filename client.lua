local QBCore = exports['qb-core']:GetCoreObject()

local ANIM_DICT = "mp_common"
local ANIM_NAME = "givetake1_a"

local function GetVehicleInFront()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local rayEnd = pos + forward * 5.0
    local ray = StartShapeTestRay(pos.x, pos.y, pos.z, rayEnd.x, rayEnd.y, rayEnd.z, 10, playerPed, 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(ray)
    if hit == 1 and DoesEntityExist(entityHit) and IsEntityAVehicle(entityHit) then
        return entityHit
    end
    return nil
end

local function IsPedAPlayerPed(ped)
    for _, playerId in ipairs(GetActivePlayers()) do
        if GetPlayerPed(playerId) == ped then
            return true
        end
    end
    return false
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    local timer = 0
    while not HasAnimDictLoaded(dict) and timer < 50 do
        Wait(50)
        timer = timer + 1
    end
end

RegisterNetEvent('trw:badgeUsed', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData or not PlayerData.job or PlayerData.job.name ~= 'police' then
        QBCore.Functions.Notify("Only police officers can use this.", "error")
        return
    end

    local playerPed = PlayerPedId()
    local veh = GetVehicleInFront()
    if not veh then
        QBCore.Functions.Notify("No vehicle detected in front of you.", "error")
        return
    end

    local driver = GetPedInVehicleSeat(veh, -1)
    if not driver or driver == 0 then
        QBCore.Functions.Notify("No driver in the vehicle.", "error")
        return
    end

    if driver == playerPed then
        QBCore.Functions.Notify("You are the driver.", "error")
        return
    end

    if IsPedAPlayerPed(driver) then
        QBCore.Functions.Notify("Driver is a player — cannot force keys.", "error")
        return
    end

    TaskLeaveVehicle(driver, veh, 0)
    local leaveTimeout = 0
    while IsPedInAnyVehicle(driver, false) and leaveTimeout < 100 do
        Wait(50)
        leaveTimeout = leaveTimeout + 1
    end

    TaskGoToEntity(driver, playerPed, -1, 2.0, 2.0, 1073741824.0, 0)
    local walkTimeout = 0
    while #(GetEntityCoords(driver) - GetEntityCoords(playerPed)) > 2.0 and walkTimeout < 120 do
        Wait(50)
        walkTimeout = walkTimeout + 1
    end

    LoadAnimDict(ANIM_DICT)
    TaskPlayAnim(driver, ANIM_DICT, ANIM_NAME, 8.0, -8.0, 2000, 0, 0, false, false, false)
    TaskPlayAnim(playerPed, ANIM_DICT, ANIM_NAME, 8.0, -8.0, 2000, 0, 0, false, false, false)
    Wait(1000)

    local plate = GetVehicleNumberPlateText(veh) or ""
    if plate == "" then
        QBCore.Functions.Notify("Could not read vehicle plate.", "error")
        return
    end

    TriggerServerEvent('trw:server:GiveKeys', plate)
    QBCore.Functions.Notify("The driver handed you the keys.", "success")
    Wait(400)
    ClearPedTasks(driver)
    TaskSmartFleePed(driver, playerPed, 100.0, -1, true, true)
end)
