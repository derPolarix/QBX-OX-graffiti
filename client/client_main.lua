rotationCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 0)
sprayingParticle = nil
placingObject = nil
sprayingCan = nil
isPlacing = false
canPlace = false
isLoaded = false

CreateThread(function()
    RequestModel(GetHashKey('a_m_m_rurmeth_01'))
    while not HasModelLoaded(GetHashKey('a_m_m_rurmeth_01')) do
        Wait(0)
    end

    local blip = AddBlipForCoord(vector3(109.24, -1090.58, 28.3))

    SetBlipSprite(blip, 72)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 17)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t('blip.graffiti_shop'))
    EndTextCommandSetBlipName(blip)

    local npc = CreatePed(4, GetHashKey('a_m_m_rurmeth_01'), vector3(109.24, -1090.58, 28.3), 347.5, false, false)
    
    SetPedFleeAttributes(npc, 0, 0)
    SetEntityInvincible(npc , true)
    FreezeEntityPosition(npc, true)
    SetPedDiesWhenInjured(npc, false)
    SetPedDropsWeaponsWhenDead(npc, false)
    SetBlockingOfNonTemporaryEvents(npc, true)

    exports.ox_target:addLocalEntity(npc, {
        {
            name = 'graffiti_shop',
            event = 'qb-graffiti:client:graffitiShop',
            icon = 'fa-solid fa-palette',
            label = Lang:t('target.graffiti_shop'),
            distance = 3.0
        }
    })    

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if isLoaded then
            for k,v in pairs(Config.Graffitis) do
                local information = GetInfo(tonumber(v.model))

                if information then
                    if #(coords - v.coords) < 100.0 then
                        if not DoesEntityExist(v.entity) then
                            RequestModel(tonumber(v.model))
                            while not HasModelLoaded(tonumber(v.model)) do
                                Wait(0)
                            end

                            v.entity = CreateObjectNoOffset(tonumber(v.model), v.coords, false, false)
                            SetEntityRotation(v.entity, v.rotation.x, v.rotation.y, v.rotation.z)
                            FreezeEntityPosition(v.entity, true)
                        end
                    else
                        if DoesEntityExist(v.entity) then
                            DeleteEntity(v.entity)
                            v.entity = nil
                        end
                    end

                    if information.blip == true then
                        if not DoesBlipExist(v.blip) then
                            v.blip = AddBlipForRadius(v.coords, 100.0)
                            SetBlipAlpha(v.blip, 100)
                            SetBlipColour(v.blip, information.blipcolor)
                        end
                    end
                end
            end
        end

        Wait(1000)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    if not isLoaded then
        QBCore.Functions.TriggerCallback('qb-graffiti:server:getGraffitiData', function(data)
            Config.Graffitis = data
            isLoaded = true
        end)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if isLoaded then
        isLoaded = false

        for k,v in pairs(Config.Graffitis) do
            if v then
                if DoesEntityExist(v.entity) then
                    DeleteEntity(v.entity)
                end
    
                if DoesBlipExist(v.blip) then
                    RemoveBlip(v.blip)
                end
            end
        end
    
        Config.Graffitis = {}
    end
end)

RegisterNetEvent('qb-graffiti:client:setGraffitiData', function(data)
    if isLoaded then
        for k,v in pairs(Config.Graffitis) do
            if v then
                if DoesEntityExist(v.entity) then
                    DeleteEntity(v.entity)
                end

                if DoesBlipExist(v.blip) then
                    RemoveBlip(v.blip)
                end
            end
        end

        Config.Graffitis = data
    end
end)

RegisterNetEvent('qb-graffiti:client:placeGraffiti', function(model, slot)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local information = GetInfo(model)
    local ped = PlayerPedId()

    if Config.Debug then print("DEBUG - Graffiti Platzieren: Model:", model, "Slot:", slot) end

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if Config.Debug then print("DEBUG - Player is in a vehicle") end
        return
    end

    if isPlacing then
        if Config.Debug then print("DEBUG - Bereits ein Graffiti wird platziert!") end
        return
    end

    if isLoaded then
        if information then
            if Config.Debug then print("DEBUG - GetInfo erfolgreich: ", json.encode(information)) end

            if information.gang then
                if PlayerData.gang and PlayerData.gang.name ~= information.gang then
                    if Config.Debug then print("DEBUG - Spieler gehört nicht zur benötigten Gang!") end
                    return QBCore.Functions.Notify(Lang:t('error.gang_only'), 'error')
                end
            end

            PlaceGraffiti(model, function(result, coords, rotation)
                if Config.Debug then print("DEBUG - PlaceGraffiti Ergebnis:", result, "Coords:", coords, "Rotation:", rotation) end

                if result then
                    local tempAlpha = 0
                    local tempSpray = CreateObjectNoOffset(model, coords, false, false, false)
                    TriggerServerEvent('qb-graffiti:server:removeServerItem', 'spraycan', 1, slot)

                    SetEntityRotation(tempSpray, rotation.x, rotation.y, rotation.z)
                    FreezeEntityPosition(tempSpray, true)
                    SetEntityAlpha(tempSpray, 0, false)

                    CreateThread(function()
                        while tempAlpha < 255 do
                            tempAlpha = tempAlpha + 51
                            SetEntityAlpha(tempSpray, tempAlpha, false)
                            Wait(8000)
                        end
                    end)

                    SprayingAnim()

                    QBCore.Functions.Progressbar('spraying_on_wall', Lang:t('progressbar.spraying_on_wall'), 40000, false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
                        StopAnimTask(ped, 'switch@franklin@lamar_tagging_wall', 'lamar_tagging_exit_loop_lamar', 1.0)
                        StopParticleFxLooped(sprayingParticle, true)
                        DeleteObject(sprayingCan)
                        DeleteObject(tempSpray)
                        sprayingParticle = nil
                        sprayingCan = nil

                        TriggerServerEvent('qb-graffiti:client:addServerGraffiti', model, coords, rotation)
                    end)
                else
                    if Config.Debug then print("DEBUG - PlaceGraffiti hat fehlgeschlagen!") end
                end
            end)
        else
            if Config.Debug then print("DEBUG - GetInfo hat `nil` zurückgegeben!") end
            QBCore.Functions.Notify(Lang:t('error.not_information'), 'error')
        end
    end
end)

RegisterNetEvent('qb-graffiti:client:removeClosestGraffiti', function(slot)
    local ped = PlayerPedId()
    local graffiti = GetClosestGraffiti(5.0)

    if isLoaded then
        if not graffiti then
            QBCore.Functions.Notify(Lang:t('error.not_found'), 'error')
        else
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)
            TriggerServerEvent('qb-graffiti:server:removeServerItem', 'sprayremover', 1, slot)

            QBCore.Functions.Progressbar('spraying_on_wall', Lang:t('progressbar.washing_the_wall'), 20000, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                ClearPedTasks(ped)

                TriggerServerEvent('qb-graffiti:server:removeServerGraffitiByKey', tonumber(graffiti))
            end)
        end
    end
end)

RegisterNetEvent('qb-graffiti:client:graffitiShop', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local graffitiMenu = {}

    if isLoaded then
        table.insert(graffitiMenu, {
            title = Lang:t('menu.graffiti_shop'),
            icon = 'fa-solid fa-palette',
            disabled = true
        })

        for k, v in pairs(Config.Sprays) do
            table.insert(graffitiMenu, {
                title = v.name .. ' - ' .. v.price .. '$',
                icon = 'fa-solid fa-brush',
                disabled = CheckShopData(v.gang, PlayerData.gang),
                onSelect = function()
                    TriggerServerEvent('qb-graffiti:server:graffitiShop', {
                        model = k,
                        name = v.name,
                        price = v.price
                    })
                end
            })
        end

        lib.registerContext({
            id = 'graffiti_shop_menu',
            title = Lang:t('menu.graffiti_shop'),
            options = graffitiMenu
        })

        lib.showContext('graffiti_shop_menu')
    end
end)


AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end    
    
    Wait(2000)

    if not isLoaded then
        QBCore.Functions.TriggerCallback('qb-graffiti:server:getGraffitiData', function(data)
            Config.Graffitis = data
            isLoaded = true
        end)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for k,v in pairs(Config.Graffitis) do
        if v then
            if DoesEntityExist(v.entity) then
                DeleteEntity(v.entity)
            end
        end
    end
end)
