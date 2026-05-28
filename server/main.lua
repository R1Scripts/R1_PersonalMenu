local ESX, QBCore = nil, nil
local PendingWeaponLicenseRequests = {}
local PendingDriverLicenseRequests = {}

CreateThread(function()
    if Config.Framework == 'esx' then
        pcall(function() ESX = exports['es_extended']:getSharedObject() end)
    elseif Config.Framework == 'qb' then
        pcall(function() QBCore = exports['qb-core']:GetCoreObject() end)
    end
end)

local function QueryAwait(query, params)
    if MySQL and MySQL.query and MySQL.query.await then
        return MySQL.query.await(query, params or {})
    elseif exports.oxmysql then
        return exports.oxmysql:query_async(query, params or {})
    end
    return {}
end

local function ScalarAwait(query, params)
    if MySQL and MySQL.scalar and MySQL.scalar.await then
        return MySQL.scalar.await(query, params or {})
    elseif exports.oxmysql then
        return exports.oxmysql:scalar_async(query, params or {})
    end
    return nil
end

local function GetIdentifier(src)
    if Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.identifier or nil
    elseif Config.Framework == 'qb' and QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        return Player and Player.PlayerData and Player.PlayerData.citizenid or nil
    end
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier:find('license:') then return identifier end
    end
    return GetPlayerIdentifier(src, 0)
end


local function HasWeaponLicensePermission(src)
    if not Config.WeaponLicense or not Config.WeaponLicense.policeJobs then return true end

    if Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        local jobName = xPlayer and xPlayer.job and xPlayer.job.name
        return jobName and Config.WeaponLicense.policeJobs[jobName] == true
    elseif Config.Framework == 'qb' and QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        local jobName = Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.name
        return jobName and Config.WeaponLicense.policeJobs[jobName] == true
    end

    return Config.Framework == 'standalone'
end

local function NormalizeSex(sex)
    if not sex then return 'N/A' end
    sex = tostring(sex):lower()
    if sex == 'm' or sex == 'male' or sex == 'hombre' or sex == '0' then return _U('male') end
    if sex == 'f' or sex == 'female' or sex == 'mujer' or sex == '1' then return _U('female') end
    return tostring(sex)
end


local function LocalizeStatus(value)
    local v = tostring(value or ''):lower()
    if v == 'vigente' or v == 'valid' then return _U('valid') end
    if v == 'suspendida' or v == 'suspended' then return _U('suspended') end
    if v == 'vencida' or v == 'expired' then return _U('expired') end
    if v == 'sin licencia' or v == 'no license' then return _U('no_license') end
    return value or 'N/A'
end

local function LocalizeLicenseType(value)
    local v = tostring(value or ''):lower()
    if v == 'tipo a - automovilista' or v == 'type a - driver' then return _U('driver_type_a') end
    if v == 'tipo b - chofer particular' or v == 'type b - private chauffeur' then return _U('driver_type_b') end
    if v == 'tipo c - carga' or v == 'type c - cargo' then return _U('driver_type_c') end
    if v == 'motociclista' or v == 'motorcyclist' then return _U('driver_type_motorcycle') end
    if v == 'portación civil registrada' or v == 'registered civilian carry' then return _U('weapon_type_civil') end
    if v == 'coleccionista' or v == 'collector' then return _U('weapon_type_collector') end
    if v == 'seguridad privada' or v == 'private security' then return _U('weapon_type_security') end
    return value or 'N/A'
end

local function CalculateAge(dateString)
    if not dateString or dateString == '' then return 'N/A' end
    local y, m, d = tostring(dateString):match('(%d%d%d%d)%-(%d%d)%-(%d%d)')
    if not y then d, m, y = tostring(dateString):match('(%d%d)/(%d%d)/(%d%d%d%d)') end
    if not y then return 'N/A' end

    local now = os.date('*t')
    local age = now.year - tonumber(y)
    if now.month < tonumber(m) or (now.month == tonumber(m) and now.day < tonumber(d)) then age = age - 1 end
    return age
end

local function FormatDate(dateString)
    if not dateString or dateString == '' then return 'N/A' end
    local y, m, d = tostring(dateString):match('(%d%d%d%d)%-(%d%d)%-(%d%d)')
    if y then return ('%s/%s/%s'):format(d, m, y) end
    return tostring(dateString)
end

local function GetSqlIdentity(identifier)
    local info = { firstname = nil, lastname = nil, birthdate = 'N/A', height = 'N/A', sex = 'N/A' }
    if not identifier then return info end

    if Config.Framework == 'esx' then
        local q = ('SELECT `%s` AS firstname, `%s` AS lastname, `%s` AS birthdate, `%s` AS height, `%s` AS sex FROM `%s` WHERE `%s` = ? LIMIT 1')
            :format(Config.SQL.esxFirstnameColumn, Config.SQL.esxLastnameColumn, Config.SQL.esxBirthdateColumn, Config.SQL.esxHeightColumn, Config.SQL.esxSexColumn, Config.SQL.esxUsersTable, Config.SQL.esxIdentifierColumn)
        local rows = QueryAwait(q, { identifier })
        local row = rows and rows[1]
        if row then
            info.firstname = row.firstname
            info.lastname = row.lastname
            info.birthdate = FormatDate(row.birthdate)
            info.rawBirthdate = row.birthdate
            info.height = row.height or 'N/A'
            info.sex = NormalizeSex(row.sex)
        end
    elseif Config.Framework == 'qb' then
        local q = ('SELECT `%s` AS charinfo FROM `%s` WHERE `%s` = ? LIMIT 1')
            :format(Config.SQL.qbCharInfoColumn, Config.SQL.qbPlayersTable, Config.SQL.qbCitizenIdColumn)
        local rows = QueryAwait(q, { identifier })
        local row = rows and rows[1]
        if row and row.charinfo then
            local ok, charinfo = pcall(json.decode, row.charinfo)
            if ok and charinfo then
                info.firstname = charinfo.firstname
                info.lastname = charinfo.lastname
                info.birthdate = FormatDate(charinfo.birthdate)
                info.rawBirthdate = charinfo.birthdate
                info.height = charinfo.height or 'N/A'
                info.sex = NormalizeSex(charinfo.gender)
            end
        end
    end

    return info
end

local function GetEsxPlayerInfo(src)
    local identifier = GetIdentifier(src)
    local identity = GetSqlIdentity(identifier)
    local info = {
        identifier = identifier,
        name = GetPlayerName(src),
        firstname = identity.firstname,
        lastname = identity.lastname,
        birthdate = identity.birthdate,
        age = CalculateAge(identity.rawBirthdate or identity.birthdate),
        height = identity.height,
        sex = identity.sex,
        job = _U('no_job'),
        grade = '',
        money = 0,
        bank = 0
    }

    if not ESX then return info end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return info end

    info.name = xPlayer.getName and xPlayer.getName() or ((identity.firstname or '') .. ' ' .. (identity.lastname or ''))
    info.money = xPlayer.getMoney and xPlayer.getMoney() or 0
    local bank = xPlayer.getAccount and xPlayer.getAccount('bank') or nil
    info.bank = bank and bank.money or 0

    if xPlayer.job then
        info.job = xPlayer.job.label or xPlayer.job.name or _U('no_job')
        info.grade = xPlayer.job.grade_label or xPlayer.job.grade_name or ''
        info.jobName = xPlayer.job.name
    end

    return info
end

local function GetQbPlayerInfo(src)
    local identifier = GetIdentifier(src)
    local identity = GetSqlIdentity(identifier)
    local info = {
        identifier = identifier,
        name = GetPlayerName(src),
        firstname = identity.firstname,
        lastname = identity.lastname,
        birthdate = identity.birthdate,
        age = CalculateAge(identity.rawBirthdate or identity.birthdate),
        height = identity.height,
        sex = identity.sex,
        job = _U('no_job'),
        grade = '',
        money = 0,
        bank = 0
    }

    if not QBCore then return info end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Player.PlayerData then return info end

    local charinfo = Player.PlayerData.charinfo or {}
    info.name = ((charinfo.firstname or info.firstname or '') .. ' ' .. (charinfo.lastname or info.lastname or '')):gsub('^%s*(.-)%s*$', '%1')
    if info.name == '' then info.name = GetPlayerName(src) end
    info.firstname = charinfo.firstname or info.firstname
    info.lastname = charinfo.lastname or info.lastname
    info.birthdate = FormatDate(charinfo.birthdate or identity.birthdate)
    info.age = CalculateAge(charinfo.birthdate or identity.rawBirthdate)
    info.height = charinfo.height or identity.height
    info.sex = NormalizeSex(charinfo.gender or identity.sex)

    local money = Player.PlayerData.money or {}
    info.money = money.cash or 0
    info.bank = money.bank or 0

    local job = Player.PlayerData.job or {}
    info.job = job.label or job.name or _U('no_job')
    info.jobName = job.name
    info.grade = job.grade and (job.grade.name or job.grade.level) or ''

    return info
end

local function GetPlayerInfo(src)
    if Config.Framework == 'esx' then return GetEsxPlayerInfo(src) end
    if Config.Framework == 'qb' then return GetQbPlayerInfo(src) end
    local identifier = GetIdentifier(src)
    local identity = GetSqlIdentity(identifier)
    return {
        identifier = identifier,
        name = GetPlayerName(src),
        firstname = identity.firstname,
        lastname = identity.lastname,
        birthdate = identity.birthdate,
        age = CalculateAge(identity.rawBirthdate or identity.birthdate),
        height = identity.height,
        sex = identity.sex,
        job = 'Standalone',
        grade = '',
        money = 0,
        bank = 0
    }
end

local function GetDocumentDesign(docType)
    docType = docType or 'id'
    return (Config.DocumentDesigns and Config.DocumentDesigns[docType]) or (Config.DocumentDesigns and Config.DocumentDesigns.id) or {}
end

local function BuildDocumentData(src, docType)
    docType = docType or 'id'
    local info = GetPlayerInfo(src)
    local design = GetDocumentDesign(docType)
    local photo = ScalarAwait('SELECT photo FROM r1_personal_documents WHERE identifier = ? AND document_type = ? LIMIT 1', { info.identifier, 'id' })

    local extraValue = design.extraFallback or 'N/A'
    local status = _U('valid')
    local topStatus = _U('valid')
    local issuedAt = 'N/A'
    local weaponSerial = nil

    if docType == 'driver' then
        status = Config.DriverLicense and Config.DriverLicense.defaultStatus or _U('no_license')
        topStatus = status
        extraValue = Config.DriverLicense and Config.DriverLicense.defaultType or (design.licenseType or _U('driver_type_a'))

        local rows = QueryAwait('SELECT license_type, status, created_at FROM r1_driver_licenses WHERE identifier = ? LIMIT 1', { info.identifier })
        local row = rows and rows[1]
        if row then
            extraValue = LocalizeLicenseType(row.license_type or extraValue)
            status = LocalizeStatus(row.status or _U('valid'))
            topStatus = status
            issuedAt = row.created_at or 'N/A'
        end
    elseif docType == 'weapon' then
        status = _U('no_license')
        topStatus = _U('no_license')
        extraValue = design.licenseType or _U('weapon_type_civil')

        local rows = QueryAwait('SELECT id, license_type, status, created_at FROM r1_weapon_licenses WHERE identifier = ? LIMIT 1', { info.identifier })
        local row = rows and rows[1]
        if row then
            extraValue = LocalizeLicenseType(row.license_type or extraValue)
            status = LocalizeStatus(row.status or _U('valid'))
            topStatus = status
            issuedAt = row.created_at or 'N/A'

            local weaponRows = QueryAwait('SELECT weapon_serial FROM r1_weapon_registrations WHERE identifier = ? AND license_id = ? ORDER BY id DESC LIMIT 1', { info.identifier, row.id })
            if weaponRows and weaponRows[1] then
                weaponSerial = weaponRows[1].weapon_serial
            end
        else
            -- Si la licencia fue comprada/entregada por ox_inventory o esx_license,
            -- también la mostramos como vigente en la NUI.
            local hasOxLicense = ScalarAwait('SELECT 1 FROM `user_licenses` WHERE `type` = ? AND `owner` = ? LIMIT 1', {
                (Config.WeaponLicense and Config.WeaponLicense.oxLicenseName) or 'weapon',
                info.identifier
            })

            if hasOxLicense then
                extraValue = LocalizeLicenseType(extraValue)
                status = _U('valid')
                topStatus = _U('valid')
            end
        end
    end

    return {
        type = docType,
        title = design.title or _U('document_id_title'),
        typeLabel = design.typeLabel or _U('document_id_type'),
        footer = design.footer or _U('nui').footer,
        extraTitle = design.extraTitle or 'Clave',
        extraValue = extraValue,
        status = status,
        topStatus = topStatus,
        issuedAt = issuedAt,
        weaponSerial = weaponSerial,
        server = Config.ServerNationality,
        photo = photo or Config.DocumentPhoto.defaultPhoto,
        name = info.name,
        firstname = info.firstname,
        lastname = info.lastname,
        age = info.age,
        height = info.height,
        sex = info.sex,
        birthdate = info.birthdate,
        key = info.identifier,
        identifier = info.identifier,
        nationality = Config.ServerNationality
    }
end

local function GetClosestPlayer(src, radius)
    local srcPed = GetPlayerPed(src)
    if not srcPed or srcPed == 0 then return nil end
    local srcCoords = GetEntityCoords(srcPed)
    local closest, closestDist = nil, radius or 3.0

    for _, id in ipairs(GetPlayers()) do
        local target = tonumber(id)
        if target and target ~= src then
            local ped = GetPlayerPed(target)
            if ped and ped ~= 0 then
                local dist = #(srcCoords - GetEntityCoords(ped))
                if dist <= closestDist then
                    closest = target
                    closestDist = dist
                end
            end
        end
    end

    return closest
end

local function NormalizeWeaponName(name)
    return string.lower(tostring(name or ''))
end

local function IsWeaponAllowed(name)
    local list = Config.WeaponLicense and (Config.WeaponLicense.RegisterWeapons or Config.WeaponLicense.allowedWeapons) or {}
    return list[NormalizeWeaponName(name)] == true
end

local function IsWeaponConfigured(name)
    local list = Config.WeaponLicense and (Config.WeaponLicense.RegisterWeapons or Config.WeaponLicense.allowedWeapons) or {}
    return list[NormalizeWeaponName(name)] ~= nil
end

local function GetWeaponSerial(item)
    local metadata = item and item.metadata or {}
    if type(metadata) ~= 'table' then metadata = {} end
    return metadata.serial or metadata.serie or metadata.weaponSerial or metadata.id or metadata.registerId
end

local function GetPlayerInventoryWeapons(src)
    local weapons = {}

    if GetResourceState('ox_inventory') == 'started' then
        local ok, items = pcall(function()
            return exports.ox_inventory:GetInventoryItems(src)
        end)

        if ok and items then
            for slot, item in pairs(items) do
                if item and item.name then
                    local name = NormalizeWeaponName(item.name)
                    if name:find('weapon_', 1, true) or IsWeaponConfigured(name) then
                        local serial = GetWeaponSerial(item)
                        local registered = false
                        if serial and serial ~= '' then
                            local found = ScalarAwait('SELECT id FROM r1_weapon_registrations WHERE weapon_serial = ? LIMIT 1', { serial })
                            registered = found ~= nil
                        end

                        weapons[#weapons + 1] = {
                            slot = item.slot or slot,
                            name = name,
                            label = item.label or item.name,
                            serial = serial,
                            allowed = IsWeaponAllowed(name),
                            registered = registered
                        }
                    end
                end
            end
        end

        return weapons, 'ox_inventory'
    end

    if Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        local loadout = xPlayer and xPlayer.getLoadout and xPlayer.getLoadout() or {}
        for i, weapon in pairs(loadout) do
            local name = NormalizeWeaponName(weapon.name)
            if name ~= '' then
                weapons[#weapons + 1] = {
                    slot = i,
                    name = name,
                    label = weapon.label or weapon.name,
                    serial = weapon.serial or weapon.tintIndex,
                    allowed = IsWeaponAllowed(name),
                    registered = false
                }
            end
        end
        return weapons, 'esx_loadout'
    end

    return weapons, 'none'
end

local function FindTargetWeapon(src, slot, name, serial)
    name = NormalizeWeaponName(name)
    local weapons = GetPlayerInventoryWeapons(src)

    for _, weapon in ipairs(weapons or {}) do
        local sameSlot = tostring(weapon.slot or '') == tostring(slot or '')
        local sameName = NormalizeWeaponName(weapon.name) == name
        local sameSerial = tostring(weapon.serial or '') == tostring(serial or '')

        if sameSlot and sameName and sameSerial then
            return weapon
        end
    end

    return nil
end

local function GetOxWeaponLicenseName()
    return (Config.WeaponLicense and Config.WeaponLicense.oxLicenseName) or 'weapon'
end

local function IsWeaponLicenseValid(status)
    local value = tostring(status or 'Vigente'):lower()
    return value == 'vigente' or value == 'valid'
end

local function SyncOxWeaponLicense(identifier, status)
    local licenseName = GetOxWeaponLicenseName()

    if not identifier or not licenseName or licenseName == '' then
        return
    end

    if IsWeaponLicenseValid(status) then
        local exists = ScalarAwait('SELECT 1 FROM `user_licenses` WHERE `type` = ? AND `owner` = ? LIMIT 1', {
            licenseName,
            identifier
        })

        if not exists then
            QueryAwait('INSERT INTO `user_licenses` (`type`, `owner`) VALUES (?, ?)', {
                licenseName,
                identifier
            })
        end
    else
        QueryAwait('DELETE FROM `user_licenses` WHERE `type` = ? AND `owner` = ?', {
            licenseName,
            identifier
        })
    end
end

local function EnsureWeaponLicense(identifier, officerId, licenseType, status)
    status = status or 'Vigente'

    QueryAwait([[
        INSERT INTO r1_weapon_licenses
            (identifier, license_type, officer_identifier, officer_name, status)
        VALUES
            (?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            license_type = VALUES(license_type),
            officer_identifier = VALUES(officer_identifier),
            officer_name = VALUES(officer_name),
            status = VALUES(status),
            updated_at = CURRENT_TIMESTAMP
    ]], {
        identifier,
        licenseType or (Config.WeaponLicense and Config.WeaponLicense.defaultType) or 'Portación civil registrada',
        GetIdentifier(officerId),
        GetPlayerName(officerId),
        status
    })

    -- Esto es lo que usa ox_inventory / esx_license para permitir comprar armas.
    SyncOxWeaponLicense(identifier, status)

    return ScalarAwait('SELECT id FROM r1_weapon_licenses WHERE identifier = ? LIMIT 1', { identifier })
end

RegisterNetEvent('R1_PersonalMenu:server:requestPlayerInfo', function()
    local src = source
    TriggerClientEvent('R1_PersonalMenu:client:receivePlayerInfo', src, GetPlayerInfo(src))
end)

RegisterNetEvent('R1_PersonalMenu:server:requestDocument', function(docType)
    local src = source
    TriggerClientEvent('R1_PersonalMenu:client:openDocument', src, BuildDocumentData(src, docType))
end)


RegisterNetEvent('R1_PersonalMenu:server:saveDocumentPhoto', function(photoData)
    local src = source
    local identifier = GetIdentifier(src)
    if not identifier then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('ine'), _U('no_identifier'), 4500)
        return
    end

    if type(photoData) ~= 'string' or photoData == '' then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('ine'), _U('empty_photo'), 4500)
        return
    end

    QueryAwait([[INSERT INTO r1_personal_documents (identifier, document_type, photo)
        VALUES (?, 'id', ?)
        ON DUPLICATE KEY UPDATE photo = VALUES(photo), updated_at = CURRENT_TIMESTAMP]], { identifier, photoData })

    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'success', _U('ine'), _U('photo_saved'), 4500)
end)

RegisterNetEvent('R1_PersonalMenu:server:showDocumentNearby', function(docType)
    local src = source
    local target = GetClosestPlayer(src, 3.0)
    if not target then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('nui').documents, _U('no_players_near'), 3500)
        return
    end

    TriggerClientEvent('R1_PersonalMenu:client:openDocument', target, BuildDocumentData(src, docType))
    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'success', _U('nui').documents, _U('showed_id_nearby'), 3500)
end)



local function EnsureDriverLicense(identifier, officerId, licenseType, status)
    QueryAwait([[INSERT INTO r1_driver_licenses (identifier, license_type, status, officer_identifier, created_at)
        VALUES (?, ?, ?, ?, NOW())
        ON DUPLICATE KEY UPDATE
            license_type = VALUES(license_type),
            status = VALUES(status),
            officer_identifier = VALUES(officer_identifier),
            created_at = NOW()]], {
        identifier,
        licenseType or (Config.DriverLicense and Config.DriverLicense.defaultType) or 'Tipo A - Automovilista',
        status or 'Vigente',
        GetIdentifier(officerId)
    })
end

RegisterNetEvent('R1_PersonalMenu:server:requestDriverLicenseCitizen', function()
    local src = source
    if not HasWeaponLicensePermission(src) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_permission_licenses'), 4000)
        return
    end

    local radius = (Config.WeaponLicense and Config.WeaponLicense.requestDistance) or 3.0
    local target = GetClosestPlayer(src, radius)
    if not target then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_citizens_near'), 3500)
        return
    end

    PendingDriverLicenseRequests[target] = {
        officer = src,
        expires = os.time() + math.floor(((Config.WeaponLicense and Config.WeaponLicense.requestTimeout) or 15000) / 1000)
    }

    TriggerClientEvent('R1_PersonalMenu:client:driverLicenseRequest', target, {
        officerId = src,
        timeout = (Config.WeaponLicense and Config.WeaponLicense.requestTimeout) or 15000
    })
    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'info', _U('licenses'), _U('request_sent_citizen'), 3500)
end)

RegisterNetEvent('R1_PersonalMenu:server:acceptDriverLicenseCitizen', function(officerId)
    local target = source
    local request = PendingDriverLicenseRequests[target]
    if not request or request.officer ~= officerId or os.time() > request.expires then
        PendingDriverLicenseRequests[target] = nil
        TriggerClientEvent('R1_PersonalMenu:client:notify', target, 'error', _U('licenses'), _U('invalid_request'), 3500)
        return
    end
    PendingDriverLicenseRequests[target] = nil

    if not HasWeaponLicensePermission(officerId) then return end

    local info = GetPlayerInfo(target)
    TriggerClientEvent('R1_PersonalMenu:client:openDriverLicensePanel', officerId, {
        targetId = target,
        name = info.name,
        age = info.age,
        height = info.height,
        sex = info.sex,
        document = BuildDocumentData(target, 'id')
    })
end)

RegisterNetEvent('R1_PersonalMenu:server:issueDriverLicense', function(targetId, licenseType, status)
    local src = source
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('player_not_connected'), 3500)
        return
    end
    if not HasWeaponLicensePermission(src) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_permission'), 3500)
        return
    end

    local targetIdentifier = GetIdentifier(targetId)
    if not targetIdentifier then return end
    EnsureDriverLicense(targetIdentifier, src, licenseType, status)
    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'success', _U('licenses'), _U('driver_license_given'), 4500)
    TriggerClientEvent('R1_PersonalMenu:client:notify', targetId, 'info', _U('licenses'), _U('driver_license_received'), 4500)
end)

RegisterNetEvent('R1_PersonalMenu:server:requestWeaponLicenseCitizen', function()
    local src = source

    if not HasWeaponLicensePermission(src) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_permission_licenses'), 4500)
        return
    end

    local radius = (Config.WeaponLicense and Config.WeaponLicense.requestDistance) or 3.0
    local target = GetClosestPlayer(src, radius)

    if not target then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_citizens_id_near'), 4500)
        return
    end

    PendingWeaponLicenseRequests[target] = {
        officer = src,
        expires = os.time() + math.floor(((Config.WeaponLicense and Config.WeaponLicense.requestTimeout) or 15000) / 1000)
    }

    TriggerClientEvent('R1_PersonalMenu:client:weaponLicenseRequest', target, {
        officerId = src,
        officerName = GetPlayerName(src),
        timeout = (Config.WeaponLicense and Config.WeaponLicense.requestTimeout) or 15000
    })

    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'info', _U('licenses'), _U('request_sent_wait_ine'), 5000)
end)

RegisterNetEvent('R1_PersonalMenu:server:acceptWeaponLicenseCitizen', function(officerId)
    local target = source
    officerId = tonumber(officerId)

    local request = PendingWeaponLicenseRequests[target]
    if not request or request.officer ~= officerId or os.time() > request.expires then
        PendingWeaponLicenseRequests[target] = nil
        TriggerClientEvent('R1_PersonalMenu:client:notify', target, 'error', _U('licenses'), _U('invalid_request'), 3500)
        return
    end

    PendingWeaponLicenseRequests[target] = nil

    if not GetPlayerName(officerId) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', target, 'error', _U('licenses'), _U('officer_offline'), 3500)
        return
    end

    if not HasWeaponLicensePermission(officerId) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', target, 'error', _U('licenses'), _U('officer_no_permission'), 3500)
        return
    end

    local info = GetPlayerInfo(target)
    local weapons, inventoryType = GetPlayerInventoryWeapons(target)

    TriggerClientEvent('R1_PersonalMenu:client:openWeaponLicensePanel', officerId, {
        targetId = target,
        name = info.name,
        age = info.age,
        height = info.height,
        sex = info.sex,
        birthdate = info.birthdate,
        identifier = info.identifier,
        document = BuildDocumentData(target, 'id'),
        weapons = weapons,
        inventoryType = inventoryType
    })

    TriggerClientEvent('R1_PersonalMenu:client:notify', target, 'success', _U('licenses'), _U('showed_id_officer'), 3500)
end)

RegisterNetEvent('R1_PersonalMenu:server:issueWeaponLicense', function(targetId, licenseType, status)
    local src = source
    targetId = tonumber(targetId)

    if not HasWeaponLicensePermission(src) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_permission_give_licenses'), 4500)
        return
    end

    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('player_not_connected'), 4000)
        return
    end

    local targetIdentifier = GetIdentifier(targetId)
    if not targetIdentifier then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_player_identifier'), 4500)
        return
    end

    EnsureWeaponLicense(targetIdentifier, src, licenseType, status)

    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'success', _U('licenses'), _U('weapon_license_updated'), 4500)
    TriggerClientEvent('R1_PersonalMenu:client:notify', targetId, 'info', _U('licenses'), _U('weapon_license_received_update'), 4500)
end)

RegisterNetEvent('R1_PersonalMenu:server:registerWeaponToLicense', function(targetId, slot, weaponName, serial)
    local src = source
    targetId = tonumber(targetId)

    if not HasWeaponLicensePermission(src) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_permission_register_weapons'), 4500)
        return
    end

    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('player_not_connected'), 4000)
        return
    end

    local weapon = FindTargetWeapon(targetId, slot, weaponName, serial)
    if not weapon then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('weapon_not_found'), 5000)
        return
    end

    if weapon.allowed ~= true then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('weapon_not_allowed'), 6500)
        return
    end

    if not weapon.serial or weapon.serial == '' then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('weapon_no_serial'), 6500)
        return
    end

    local existing = ScalarAwait('SELECT id FROM r1_weapon_registrations WHERE weapon_serial = ? LIMIT 1', { weapon.serial })
    if existing then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('weapon_already_registered'), 4500)
        return
    end

    local targetIdentifier = GetIdentifier(targetId)
    local licenseId = EnsureWeaponLicense(targetIdentifier, src, (Config.WeaponLicense and Config.WeaponLicense.defaultType) or 'Portación civil registrada', 'Vigente')

    QueryAwait([[
        INSERT INTO r1_weapon_registrations
            (license_id, identifier, weapon_name, weapon_label, weapon_serial, status, officer_identifier, officer_name)
        VALUES
            (?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        licenseId,
        targetIdentifier,
        weapon.name,
        weapon.label or weapon.name,
        weapon.serial,
        _U('registered'),
        GetIdentifier(src),
        GetPlayerName(src)
    })

    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'success', _U('licenses'), _U('weapon_registered', weapon.label or weapon.name, weapon.serial), 6500)
    TriggerClientEvent('R1_PersonalMenu:client:notify', targetId, 'info', _U('licenses'), _U('weapon_registered_target', weapon.label or weapon.name), 5000)
end)

RegisterNetEvent('R1_PersonalMenu:server:createWeaponLicense', function(targetId, licenseType, status)
    local src = source
    targetId = tonumber(targetId)

    if not HasWeaponLicensePermission(src) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_permission_give_licenses'), 4500)
        return
    end

    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('player_not_connected'), 4000)
        return
    end

    local targetIdentifier = GetIdentifier(targetId)
    local officerIdentifier = GetIdentifier(src)

    if not targetIdentifier then
        TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'error', _U('licenses'), _U('no_player_identifier'), 4500)
        return
    end

    licenseType = tostring(licenseType or ((Config.WeaponLicense and Config.WeaponLicense.defaultType) or 'Portación civil registrada'))
    status = tostring(status or 'Vigente')

    QueryAwait([[
        INSERT INTO r1_weapon_licenses
            (identifier, license_type, officer_identifier, officer_name, status)
        VALUES
            (?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            license_type = VALUES(license_type),
            officer_identifier = VALUES(officer_identifier),
            officer_name = VALUES(officer_name),
            status = VALUES(status),
            updated_at = CURRENT_TIMESTAMP
    ]], {
        targetIdentifier,
        licenseType,
        officerIdentifier,
        GetPlayerName(src),
        status
    })

    -- Sincroniza con user_licenses para que ox_inventory detecte la licencia.
    SyncOxWeaponLicense(targetIdentifier, status)

    TriggerClientEvent('R1_PersonalMenu:client:notify', src, 'success', _U('licenses'), _U('weapon_license_given'), 4500)
    TriggerClientEvent('R1_PersonalMenu:client:notify', targetId, 'info', _U('licenses'), _U('weapon_license_received'), 4500)
end)
