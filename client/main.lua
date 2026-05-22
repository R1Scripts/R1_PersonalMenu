local R1 = {}
R1.MenuOpen = false
R1.RemovedClothes = {}
R1.SavedClothes = {}
R1.WindowStates = {}
R1.VehicleStates = {}
R1.LastPlayerInfo = {}
R1.PhotoMode = false
R1.PhotoCam = nil
R1.TextUIShowing = false

local ESX, QBCore = nil, nil

CreateThread(function()
    if Config.Framework == 'esx' then
        pcall(function() ESX = exports['es_extended']:getSharedObject() end)
    elseif Config.Framework == 'qb' then
        pcall(function() QBCore = exports['qb-core']:GetCoreObject() end)
    end
end)

local function Notify(type, title, message, duration)
    duration = duration or 3500
    if Config.Notify == 'r1' then
        pcall(function() exports['R1_Notify']:Notify(type, title, message, duration) end)
    elseif Config.Notify == 'ox' then
        pcall(function() lib.notify({ type = type, title = title, description = message, duration = duration }) end)
    elseif Config.Notify == 'chat' then
        TriggerEvent('chat:addMessage', { args = { title or 'R1', message or '' } })
    end
end


local function ShowInteractionTextUI(text, icon, color)
    if R1.TextUIShowing then return end
    R1.TextUIShowing = true

    if Config.TextUI and Config.TextUI.enabled == true then
        local resource = (Config.TextUI and Config.TextUI.resource) or 'R1_TextUI'
        local payload = {
            position = (Config.TextUI and Config.TextUI.position) or 'top-center',
            style = (Config.TextUI and Config.TextUI.style) or 'tactical',
            actions = {
                {
                    key = 'E',
                    text = text or _U('interact'),
                    icon = icon or 'fa-solid fa-hand-pointer',
                    color = color or (Config.TextUI and Config.TextUI.color) or '#22c55e'
                }
            }
        }

        local ok = pcall(function()
            exports[resource]:ShowTextUI(payload)
        end)

        if not ok then
            TriggerEvent('R1_TextUI:client:Show', payload)
        end
    end
end

local function HideInteractionTextUI()
    if not R1.TextUIShowing then return end
    R1.TextUIShowing = false

    local resource = (Config.TextUI and Config.TextUI.resource) or 'R1_TextUI'

    pcall(function() exports[resource]:HideTextUI() end)
    pcall(function() exports[resource]:Hide() end)
    TriggerEvent('R1_TextUI:client:Hide')
    TriggerEvent('R1_TextUI:client:Close')
end

local function IsPoliceJobClient()
    if not Config.WeaponLicense or not Config.WeaponLicense.policeJobs then return true end

    if Config.Framework == 'esx' and ESX then
        local data = ESX.GetPlayerData()
        local jobName = data and data.job and data.job.name
        return jobName and Config.WeaponLicense.policeJobs[jobName] == true
    elseif Config.Framework == 'qb' and QBCore then
        local data = QBCore.Functions.GetPlayerData()
        local jobName = data and data.job and data.job.name
        return jobName and Config.WeaponLicense.policeJobs[jobName] == true
    end

    return Config.Framework == 'standalone'
end

local function OpenWeaponLicensePoint()
    if not Config.WeaponLicense or Config.WeaponLicense.enabled ~= true then return end

    if not IsPoliceJobClient() then
        Notify('error', _U('licenses'), _U('no_permission_point'), 4000)
        return
    end

    if lib and lib.registerContext then
        lib.registerContext({
            id = 'r1_license_type_point',
            title = _U('issue_licenses'),
            options = {
                {
                    title = _U('weapon_license'),
                    description = _U('weapon_license_desc'),
                    icon = 'gun',
                    onSelect = function()
                        TriggerServerEvent('R1_PersonalMenu:server:requestWeaponLicenseCitizen')
                    end
                },
                {
                    title = _U('driver_license'),
                    description = _U('driver_license_desc'),
                    icon = 'car-side',
                    onSelect = function()
                        TriggerServerEvent('R1_PersonalMenu:server:requestDriverLicenseCitizen')
                    end
                }
            }
        })
        lib.showContext('r1_license_type_point')
        return
    end

    TriggerServerEvent('R1_PersonalMenu:server:requestWeaponLicenseCitizen')
end

local function OpenIssueWeaponLicenseDialog(data)
    if not data or not data.targetId then return end

    if not lib or not lib.inputDialog then
        Notify('error', _U('licenses'), _U('missing_ox_form'), 5000)
        return
    end

    local licenseTypes = Config.WeaponLicense.licenseTypes or {
        { label = Config.WeaponLicense.defaultType or _U('weapon_type_civil'), value = Config.WeaponLicense.defaultType or _U('weapon_type_civil') }
    }

    local statusOptions = Config.WeaponLicense.statusOptions or {
        { label = _U('valid'), value = 'Vigente' },
        { label = _U('suspended'), value = 'Suspendida' },
        { label = _U('expired'), value = 'Vencida' }
    }

    local input = lib.inputDialog(_U('issue_weapon_license'), {
        {
            type = 'select',
            label = _U('license_type'),
            required = true,
            default = Config.WeaponLicense.defaultType or 'Portación civil registrada',
            options = licenseTypes
        },
        {
            type = 'select',
            label = _U('status'),
            required = true,
            default = 'Vigente',
            options = statusOptions
        }
    })

    if not input then return end
    TriggerServerEvent('R1_PersonalMenu:server:issueWeaponLicense', data.targetId, input[1], input[2])
end


local function OpenIssueDriverLicenseDialog(data)
    if not data or not data.targetId then return end
    if not lib or not lib.inputDialog then
        Notify('error', _U('licenses'), _U('missing_ox_form'), 5000)
        return
    end

    local driverTypes = Config.DriverLicense and Config.DriverLicense.licenseTypes or {
        { label = _U('driver_type_a'), value = 'Tipo A - Automovilista' }
    }
    local statusOptions = Config.DriverLicense and Config.DriverLicense.statusOptions or {
        { label = _U('valid'), value = 'Vigente' },
        { label = _U('suspended'), value = 'Suspendida' },
        { label = _U('expired'), value = 'Vencida' }
    }

    local input = lib.inputDialog(_U('driver_license'), {
        { type = 'select', label = _U('license_type'), options = driverTypes, default = Config.DriverLicense and Config.DriverLicense.defaultType or 'Tipo A - Automovilista', required = true },
        { type = 'select', label = _U('status'), options = statusOptions, default = 'Vigente', required = true }
    })
    if not input then return end
    TriggerServerEvent('R1_PersonalMenu:server:issueDriverLicense', data.targetId, input[1], input[2])
end

local function OpenDriverLicenseOfficerPanel(data)
    if not data or not data.targetId then return end
    if not lib or not lib.registerContext then
        Notify('error', _U('licenses'), _U('missing_ox_panel'), 5000)
        return
    end

    local options = {
        {
            title = data.name or _U('citizen'),
            description = _U('citizen_desc', data.targetId, data.age or 'N/A', data.height or 'N/A', data.sex or 'N/A'),
            icon = 'id-card',
            disabled = true
        },
        {
            title = _U('view_citizen_id'),
            description = _U('view_citizen_id_desc'),
            icon = 'address-card',
            onSelect = function()
                if data.document then
                    SetNuiFocus(true, true)
                    SendNUIMessage({ action = 'openDocument', document = data.document })
                end
            end
        },
        {
            title = _U('issue_update_driver'),
            description = _U('issue_update_driver_desc'),
            icon = 'file-signature',
            onSelect = function()
                OpenIssueDriverLicenseDialog(data)
            end
        }
    }

    lib.registerContext({ id = 'r1_driver_license_officer_panel', title = _U('driver_license'), options = options })
    lib.showContext('r1_driver_license_officer_panel')
end

local function OpenWeaponLicenseOfficerPanel(data)
    if not data or not data.targetId then return end

    if not lib or not lib.registerContext then
        Notify('error', _U('licenses'), _U('missing_ox_panel'), 5000)
        return
    end

    local options = {
        {
            title = data.name or _U('citizen'),
            description = _U('citizen_desc', data.targetId, data.age or 'N/A', data.height or 'N/A', data.sex or 'N/A'),
            icon = 'id-card',
            disabled = true
        },
        {
            title = _U('view_citizen_id'),
            description = _U('view_citizen_id_desc'),
            icon = 'address-card',
            onSelect = function()
                if data.document then
                    SetNuiFocus(true, true)
                    SendNUIMessage({ action = 'openDocument', document = data.document })
                end
            end
        },
        {
            title = _U('issue_update_license'),
            description = _U('issue_update_license_desc'),
            icon = 'file-signature',
            onSelect = function()
                OpenIssueWeaponLicenseDialog(data)
            end
        }
    }

    options[#options + 1] = {
        title = _U('inventory_weapons'),
        description = data.inventoryType or 'ox_inventory',
        icon = 'gun',
        disabled = true
    }

    if not data.weapons or #data.weapons == 0 then
        options[#options + 1] = {
            title = _U('no_weapons'),
            description = _U('no_weapons_desc'),
            icon = 'ban',
            disabled = true
        }
    else
        for _, weapon in ipairs(data.weapons) do
            local description = _U('serial', weapon.serial or _U('no_serial'))

            if weapon.registered then
                description = description .. ' | ' .. _U('already_registered')
            elseif weapon.allowed ~= true then
                description = description .. ' | ' .. _U('not_allowed')
            elseif not weapon.serial or weapon.serial == '' then
                description = description .. ' | ' .. _U('no_serial')
            else
                description = description .. ' | ' .. _U('ready_register')
            end

            options[#options + 1] = {
                title = weapon.label or weapon.name,
                description = description,
                icon = weapon.registered and 'circle-check' or (weapon.allowed and 'gun' or 'triangle-exclamation'),
                disabled = weapon.registered == true or weapon.allowed ~= true or not weapon.serial or weapon.serial == '',
                onSelect = function()
                    TriggerServerEvent('R1_PersonalMenu:server:registerWeaponToLicense', data.targetId, weapon.slot, weapon.name, weapon.serial)
                end
            }
        end
    end

    lib.registerContext({
        id = 'r1_weapon_license_officer_panel',
        title = _U('weapon_license'),
        options = options
    })

    lib.showContext('r1_weapon_license_officer_panel')
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 3000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do Wait(10) end
    return HasAnimDictLoaded(dict)
end

local function PlayTimedAnim(animData)
    if not animData or not animData.dict or not animData.anim then return end
    local ped = PlayerPedId()
    if LoadAnimDict(animData.dict) then
        TaskPlayAnim(ped, animData.dict, animData.anim, 8.0, -8.0, animData.duration or 1200, animData.flag or 49, 0.0, false, false, false)
        Wait(animData.duration or 1200)
    end
end

local function GetPedGender(ped)
    return GetEntityModel(ped) == joaat('mp_f_freemode_01') and 1 or 0
end

local function GetDefaultComponent(componentId)
    local gender = GetPedGender(PlayerPedId())
    local genderDefaults = Config.Defaults[gender]
    if not genderDefaults or not genderDefaults.components then
        return { drawable = 0, texture = 0, palette = 0 }
    end
    return genderDefaults.components[componentId] or { drawable = 0, texture = 0, palette = 0 }
end

local function SaveClothingPart(ped, itemId, part)
    R1.SavedClothes[itemId] = R1.SavedClothes[itemId] or {}
    if part.type == 'prop' then
        R1.SavedClothes[itemId][#R1.SavedClothes[itemId] + 1] = {
            type = 'prop', id = part.id,
            drawable = GetPedPropIndex(ped, part.id),
            texture = GetPedPropTextureIndex(ped, part.id)
        }
    elseif part.type == 'component' then
        R1.SavedClothes[itemId][#R1.SavedClothes[itemId] + 1] = {
            type = 'component', id = part.id,
            drawable = GetPedDrawableVariation(ped, part.id),
            texture = GetPedTextureVariation(ped, part.id),
            palette = GetPedPaletteVariation(ped, part.id)
        }
    end
end

local function RemoveClothingPart(ped, part)
    if part.type == 'prop' then
        ClearPedProp(ped, part.id)
    elseif part.type == 'component' then
        local default = GetDefaultComponent(part.id)
        SetPedComponentVariation(ped, part.id, default.drawable or 0, default.texture or 0, default.palette or 0)
    end
end


local function IsPartEmptyOrDefault(ped, part)
    if part.type == 'prop' then
        return GetPedPropIndex(ped, part.id) == -1
    elseif part.type == 'component' then
        local default = GetDefaultComponent(part.id)
        local drawable = GetPedDrawableVariation(ped, part.id)
        local texture = GetPedTextureVariation(ped, part.id)
        local palette = GetPedPaletteVariation(ped, part.id)
        return drawable == (default.drawable or 0) and texture == (default.texture or 0) and palette == (default.palette or 0)
    end
    return true
end

local function HasClothingItemEquipped(ped, item)
    if not item or not item.parts then return false end
    for _, part in pairs(item.parts) do
        if not IsPartEmptyOrDefault(ped, part) then
            return true
        end
    end
    return false
end

local function RestoreClothingItem(ped, itemId)
    local data = R1.SavedClothes[itemId]
    if not data then return end
    for _, part in pairs(data) do
        if part.type == 'prop' then
            if part.drawable and part.drawable >= 0 then
                SetPedPropIndex(ped, part.id, part.drawable, part.texture or 0, true)
            end
        elseif part.type == 'component' then
            SetPedComponentVariation(ped, part.id, part.drawable or 0, part.texture or 0, part.palette or 0)
        end
    end
end

local function ToggleClothingItem(itemId)
    local ped = PlayerPedId()
    for _, item in pairs(Config.ClothingItems) do
        if item.id == itemId then
            if not R1.RemovedClothes[itemId] and not HasClothingItemEquipped(ped, item) then
                Notify('error', _U('clothes'), _U('nothing_to_remove'), 3500)
                return
            end

            PlayTimedAnim(Config.ClothingAnimations[itemId] or Config.ClothingAnimations.default)

            if R1.RemovedClothes[itemId] then
                RestoreClothingItem(ped, itemId)
                R1.RemovedClothes[itemId] = false
                R1.SavedClothes[itemId] = nil
            else
                R1.SavedClothes[itemId] = {}
                for _, part in pairs(item.parts) do
                    SaveClothingPart(ped, itemId, part)
                    RemoveClothingPart(ped, part)
                end
                R1.RemovedClothes[itemId] = true
            end

            SendNUIMessage({ action = 'updateClothingItem', id = itemId, removed = R1.RemovedClothes[itemId] == true })
            break
        end
    end
end

local function GetClosestVehicleSafe()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then return vehicle end

    local coords = GetEntityCoords(ped)
    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then return vehicle end
    return nil
end

local function GetVehicleStatePayload()
    local vehicle = GetClosestVehicleSafe()
    local states = {}

    for _, option in pairs(Config.VehicleOptions) do
        states[option.id] = false
    end

    if not vehicle then return states end

    for _, option in pairs(Config.VehicleOptions) do
        if option.action == 'vehicle_door' and option.door then
            states[option.id] = GetVehicleDoorAngleRatio(vehicle, option.door) > 0.1
        elseif option.action == 'vehicle_engine' then
            states[option.id] = not GetIsVehicleEngineRunning(vehicle)
        elseif option.action == 'vehicle_window' and option.window then
            states[option.id] = R1.WindowStates[option.window] == true
        elseif option.action == 'vehicle_seat' and option.seat then
            states[option.id] = GetPedInVehicleSeat(vehicle, option.seat) == PlayerPedId()
        elseif option.action == 'vehicle_plate' then
            states[option.id] = true
        end
    end

    return states
end

local function UpdateVehicleStates()
    SendNUIMessage({ action = 'vehicleStates', states = GetVehicleStatePayload() })
end

local function ToggleVehicleEngine()
    local vehicle = GetClosestVehicleSafe()
    if not vehicle then return Notify('error', _U('vehicle'), _U('no_vehicle_near'), 3500) end
    local running = GetIsVehicleEngineRunning(vehicle)
    SetVehicleEngineOn(vehicle, not running, false, true)
    Notify('info', _U('vehicle'), running and _U('engine_off') or _U('engine_on'), 2500)
    Wait(150)
    UpdateVehicleStates()
end

local function ToggleVehicleDoor(door)
    local vehicle = GetClosestVehicleSafe()
    if not vehicle then return Notify('error', _U('vehicle'), _U('no_vehicle_near'), 3500) end
    if GetVehicleDoorAngleRatio(vehicle, door) > 0.1 then
        SetVehicleDoorShut(vehicle, door, false)
    else
        SetVehicleDoorOpen(vehicle, door, false, false)
    end
    Wait(150)
    UpdateVehicleStates()
end

local function ToggleVehicleWindow(window)
    local vehicle = GetClosestVehicleSafe()
    if not vehicle then return Notify('error', _U('vehicle'), _U('no_vehicle_near'), 3500) end
    R1.WindowStates[window] = not R1.WindowStates[window]
    if R1.WindowStates[window] then
        RollDownWindow(vehicle, window)
    else
        RollUpWindow(vehicle, window)
    end
    UpdateVehicleStates()
end

local function ChangeSeat(seat)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return Notify('error', _U('vehicle'), _U('must_be_in_vehicle'), 3500) end

    seat = tonumber(seat)
    if not seat then return end

    if IsVehicleSeatFree(vehicle, seat) or GetPedInVehicleSeat(vehicle, seat) == ped then
        TaskWarpPedIntoVehicle(ped, vehicle, seat)
        Wait(250)
        UpdateVehicleStates()
    else
        Notify('error', _U('vehicle'), _U('seat_occupied'), 3000)
    end
end

local function ShowPlate()
    local vehicle = GetClosestVehicleSafe()
    if not vehicle then return Notify('error', _U('vehicle'), _U('no_vehicle_near'), 3500) end
    Notify('info', _U('plate'), GetVehicleNumberPlateText(vehicle), 4500)
end

local function PlayAnimation(animData)
    local ped = PlayerPedId()
    ClearPedTasks(ped)

    if animData.action == 'clear_anim' then
        ClearPedTasksImmediately(ped)
        return
    end

    if animData.scenario then
        TaskStartScenarioInPlace(ped, animData.scenario, 0, true)
        return
    end

    if animData.dict and animData.anim and LoadAnimDict(animData.dict) then
        TaskPlayAnim(ped, animData.dict, animData.anim, 8.0, -8.0, -1, animData.flag or 49, 0.0, false, false, false)
    end
end

local function ExecuteConfiguredCommand(command)
    if not command or command == '' then return end
    ExecuteCommand(command)
end

local function HandleMenuAction(action, data)
    data = data or {}

    if action == 'command' then
        ExecuteConfiguredCommand(data.command)
    elseif action == 'vehicle_engine' then
        ToggleVehicleEngine()
    elseif action == 'vehicle_door' then
        ToggleVehicleDoor(tonumber(data.door) or 0)
    elseif action == 'vehicle_window' then
        ToggleVehicleWindow(tonumber(data.window) or 0)
    elseif action == 'vehicle_seat' then
        ChangeSeat(tonumber(data.seat) or -1)
    elseif action == 'vehicle_plate' then
        ShowPlate()
    elseif action == 'view_id' then
        TriggerServerEvent('R1_PersonalMenu:server:requestDocument', 'id', false)
    elseif action == 'show_id' then
        TriggerServerEvent('R1_PersonalMenu:server:showDocumentNearby', 'id')
    elseif action == 'view_driver_license' then
        TriggerServerEvent('R1_PersonalMenu:server:requestDocument', 'driver', false)
    elseif action == 'show_driver_license' then
        TriggerServerEvent('R1_PersonalMenu:server:showDocumentNearby', 'driver')
    elseif action == 'view_weapon_license' then
        TriggerServerEvent('R1_PersonalMenu:server:requestDocument', 'weapon', false)
    elseif action == 'show_weapon_license' then
        TriggerServerEvent('R1_PersonalMenu:server:showDocumentNearby', 'weapon')
    end
end


local function StopDocumentPhotoMode()
    if R1.PhotoCam then
        RenderScriptCams(false, true, 300, true, true)
        DestroyCam(R1.PhotoCam, false)
        R1.PhotoCam = nil
R1.TextUIShowing = false
    end
    R1.PhotoMode = false
    FreezeEntityPosition(PlayerPedId(), false)
end

local function StartDocumentPhotoMode()
    if R1.PhotoMode then return end

    if GetResourceState('screenshot-basic') ~= 'started' then
        Notify('error', _U('ine'), _U('screenshot_missing'), 6500)
        return
    end

    local ped = PlayerPedId()
    R1.PhotoMode = true
    FreezeEntityPosition(ped, true)
    ClearPedTasks(ped)

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local camOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.85, 0.68)

    R1.PhotoCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(R1.PhotoCam, camOffset.x, camOffset.y, camOffset.z)
    PointCamAtCoord(R1.PhotoCam, coords.x, coords.y, coords.z + 0.62)
    SetCamFov(R1.PhotoCam, 36.0)
    RenderScriptCams(true, true, 450, true, true)

    Notify('info', _U('ine'), _U('camera_ready', Config.DocumentPhoto.key or 'H'), 8500)

    CreateThread(function()
        local key = Config.DocumentPhoto.control or 74
        local timeout = GetGameTimer() + (Config.DocumentPhoto.timeout or 20000)

        while R1.PhotoMode and GetGameTimer() < timeout do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, key, true)
            EnableControlAction(0, 200, true)

            if IsControlJustPressed(0, 200) then
                StopDocumentPhotoMode()
                Notify('error', _U('ine'), _U('photo_cancelled'), 3000)
                return
            end

            if IsControlJustPressed(0, key) then
                exports['screenshot-basic']:requestScreenshot({ encoding = 'jpg', quality = Config.DocumentPhoto.quality or 0.72 }, function(data)
                    StopDocumentPhotoMode()
                    if data and data ~= '' then
                        TriggerServerEvent('R1_PersonalMenu:server:saveDocumentPhoto', data)
                    else
                        Notify('error', _U('ine'), _U('photo_failed'), 4500)
                    end
                end)
                return
            end
        end

        if R1.PhotoMode then
            StopDocumentPhotoMode()
            Notify('error', _U('ine'), _U('photo_timeout'), 3500)
        end
    end)
end

local function BuildLocalPlayerInfo(serverInfo)
    local ped = PlayerPedId()
    serverInfo = serverInfo or {}
    serverInfo.health = math.max(0, GetEntityHealth(ped) - 100)
    serverInfo.armor = GetPedArmour(ped)
    serverInfo.serverId = GetPlayerServerId(PlayerId())
    serverInfo.nationality = Config.ServerNationality
    return serverInfo
end

local function SendOpenData(playerInfo)
    R1.LastPlayerInfo = BuildLocalPlayerInfo(playerInfo)
    SendNUIMessage({
        action = 'open',
        title = Config.MenuTitle,
        locales = Config.NuiLocales,
        theme = Config.Theme,
        pages = Config.Pages,
        commands = Config.Commands,
        clothingItems = Config.ClothingItems,
        clothingStates = R1.RemovedClothes,
        vehicleOptions = Config.VehicleOptions,
        vehicleStates = GetVehicleStatePayload(),
        animations = Config.Animations,
        documents = Config.Documents,
        playerInfo = R1.LastPlayerInfo
    })
end

local function OpenPersonalMenu()
    if R1.MenuOpen then return end
    R1.MenuOpen = true
    SetNuiFocus(true, true)
    TriggerServerEvent('R1_PersonalMenu:server:requestPlayerInfo')
    SendOpenData({ loading = true })
end

local function ClosePersonalMenu()
    if not R1.MenuOpen then return end
    R1.MenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterCommand(Config.Command, function()
    if R1.MenuOpen then ClosePersonalMenu() else OpenPersonalMenu() end
end, false)

RegisterKeyMapping(Config.Command, _U('open_personal_menu'), 'keyboard', Config.OpenKey)

RegisterCommand(Config.DocumentPhoto.command, function()
    StartDocumentPhotoMode()
end, false)

RegisterNetEvent('R1_PersonalMenu:client:receivePlayerInfo', function(info)
    if R1.MenuOpen then SendOpenData(info or {}) end
end)

RegisterNetEvent('R1_PersonalMenu:client:openDocument', function(docData)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openDocument', document = docData })
end)

RegisterNetEvent('R1_PersonalMenu:client:weaponLicenseRequest', function(data)
    data = data or {}
    if R1.PendingLicenseRequest then return end

    R1.PendingLicenseRequest = true
    local timeout = GetGameTimer() + (data.timeout or (Config.WeaponLicense and Config.WeaponLicense.requestTimeout) or 15000)

    Notify('info', _U('licenses'), _U('officer_request_id', data.officerName or 'N/A'), 6500)
    ShowInteractionTextUI(_U('show_id_officer'), 'fa-solid fa-id-card', '#22c55e')

    CreateThread(function()
        while R1.PendingLicenseRequest and GetGameTimer() < timeout do
            Wait(0)
            if IsControlJustPressed(0, 38) then
                R1.PendingLicenseRequest = false
                HideInteractionTextUI()
                TriggerServerEvent('R1_PersonalMenu:server:acceptWeaponLicenseCitizen', data.officerId)
                return
            end

            if IsControlJustPressed(0, 200) then
                R1.PendingLicenseRequest = false
                HideInteractionTextUI()
                Notify('error', _U('licenses'), _U('request_cancelled'), 3000)
                return
            end
        end

        if R1.PendingLicenseRequest then
            R1.PendingLicenseRequest = false
            HideInteractionTextUI()
            Notify('error', _U('licenses'), _U('request_expired'), 3000)
        end
    end)
end)


RegisterNetEvent('R1_PersonalMenu:client:driverLicenseRequest', function(data)
    data = data or {}
    if R1.PendingLicenseRequest then return end
    R1.PendingLicenseRequest = true
    local timeout = GetGameTimer() + (data.timeout or 15000)

    ShowInteractionTextUI(_U('show_id_driver'), 'fa-solid fa-id-card', '#22c55e')

    CreateThread(function()
        while R1.PendingLicenseRequest and GetGameTimer() < timeout do
            Wait(0)
            if IsControlJustPressed(0, 38) then
                R1.PendingLicenseRequest = false
                HideInteractionTextUI()
                TriggerServerEvent('R1_PersonalMenu:server:acceptDriverLicenseCitizen', data.officerId)
                return
            end
        end
        if R1.PendingLicenseRequest then
            R1.PendingLicenseRequest = false
            HideInteractionTextUI()
            Notify('warning', _U('licenses'), _U('driver_request_expired'), 3500)
        end
    end)
end)

RegisterNetEvent('R1_PersonalMenu:client:openDriverLicensePanel', function(data)
    OpenDriverLicenseOfficerPanel(data or {})
end)

RegisterNetEvent('R1_PersonalMenu:client:openWeaponLicensePanel', function(data)
    OpenWeaponLicenseOfficerPanel(data or {})
end)

RegisterNetEvent('R1_PersonalMenu:client:notify', function(type, title, message, duration)
    Notify(type, title, message, duration)
end)

RegisterNUICallback('close', function(_, cb)
    ClosePersonalMenu()
    cb('ok')
end)

RegisterNUICallback('closeDocument', function(_, cb)
    if not R1.MenuOpen then SetNuiFocus(false, false) end
    SendNUIMessage({ action = 'closeDocument' })
    cb('ok')
end)

RegisterNUICallback('toggleClothing', function(data, cb)
    if data and data.id then ToggleClothingItem(data.id) end
    cb('ok')
end)

RegisterNUICallback('runAction', function(data, cb)
    if data and data.action then HandleMenuAction(data.action, data) end
    cb('ok')
end)

RegisterNUICallback('playAnimation', function(data, cb)
    if data then PlayAnimation(data) end
    cb('ok')
end)


CreateThread(function()
    if not Config.WeaponLicense or Config.WeaponLicense.enabled ~= true then return end

    local currentPoint = false

    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local insidePoint = false

        for _, point in pairs(Config.WeaponLicense.points or {}) do
            local dist = #(coords - point.coords)

            if dist <= 15.0 then
                sleep = 0
                DrawMarker(
                    2,
                    point.coords.x, point.coords.y, point.coords.z + 0.15,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    0.35, 0.35, 0.35,
                    0, 213, 255, 180,
                    false, true, 2,
                    false, nil, nil, false
                )
            end

            if dist <= (point.radius or 2.0) then
                sleep = 0
                insidePoint = true

                if not currentPoint then
                    currentPoint = true
                    ShowInteractionTextUI(point.label or _U('open_weapon_licenses'), 'fa-solid fa-id-card', '#22c55e')
                end

                if IsControlJustPressed(0, 38) then
                    OpenWeaponLicensePoint()
                end

                break
            end
        end

        if not insidePoint and currentPoint then
            currentPoint = false
            HideInteractionTextUI()
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if R1.MenuOpen then
            Wait(0)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 200, true)
            if IsControlJustPressed(0, 200) then ClosePersonalMenu() end
        else
            Wait(500)
        end
    end
end)


CreateThread(function()
    while true do
        if R1.MenuOpen then
            Wait(1000)
            UpdateVehicleStates()
        else
            Wait(1500)
        end
    end
end)
