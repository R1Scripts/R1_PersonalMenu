Config = {}

Config.Framework = 'esx' -- 'esx', 'qb', 'standalone'
Config.Locale = 'en' -- 'es' = Español, 'en' = English
Config.Command = 'personalmenu'
Config.OpenKey = 'G'
Config.MenuTitle = 'R1 PERSONAL MENU'
Config.Notify = 'r1' -- 'chat', 'ox', 'r1', 'none'

Config.TextUI = {
    enabled = true,
    resource = 'R1_TextUI',
    position = 'top-center',
    style = 'red',
    color = '#ff2448'
}

Config.Theme = {
    primary = '#0b6bff',
    secondary = '#07111f',
    accent = '#00d5ff',
    danger = '#ff2448'
}

-- Nombre que aparece como nacionalidad en la INE/documentos.
Config.ServerNationality = 'R SCRIPTS'

-- Configurable: aquí metes comandos de tu servidor.
Config.Commands = {
    { command = 'carradio', label = 'Car Radio' },
    { command = 'reloadskin', label = 'Reiniciar Ped' },
    { command = 'hud', label = 'HUD' },
    { command = 'report', label = 'Reporte' }
}

Config.PlayerInfo = {
    showHealth = true,
    showArmor = true,
    showId = true,
    showMoney = true,
    showBank = true,
    showJob = true,
    showBirthdate = true,
    showHeight = true,
    showSex = true
}

-- Campos SQL por framework.
Config.SQL = {
    esxUsersTable = 'users',
    esxIdentifierColumn = 'identifier',
    esxFirstnameColumn = 'firstname',
    esxLastnameColumn = 'lastname',
    esxBirthdateColumn = 'dateofbirth',
    esxHeightColumn = 'height',
    esxSexColumn = 'sex',

    qbPlayersTable = 'players',
    qbCitizenIdColumn = 'citizenid',
    qbCharInfoColumn = 'charinfo'
}

Config.Pages = {
    { page = 'commands', label = 'Comandos', icon = 'fa-solid fa-terminal' },
    { page = 'info', label = 'Información', icon = 'fa-solid fa-user' },
    { page = 'clothes', label = 'Ropa', icon = 'fa-solid fa-shirt' },
    { page = 'vehicle', label = 'Vehículo', icon = 'fa-solid fa-car' },
    { page = 'animations', label = 'Animaciones', icon = 'fa-solid fa-person-running' },
    { page = 'documents', label = 'Documentos', icon = 'fa-solid fa-id-card' }
}

Config.ClothingAnimations = {
    default = { dict = 'clothingtie', anim = 'try_tie_neutral_a', duration = 1200, flag = 49 },
    hat = { dict = 'missheist_agency2ahelmet', anim = 'take_off_helmet_stand', duration = 900, flag = 49 },
    mask = { dict = 'missfbi4', anim = 'takeoff_mask', duration = 1000, flag = 49 },
    glasses = { dict = 'clothingspecs', anim = 'take_off', duration = 900, flag = 49 },
    ears = { dict = 'mini@ears_defenders', anim = 'takeoff_earsdefenders_idle', duration = 900, flag = 49 },
    chain = { dict = 'clothingtie', anim = 'try_tie_positive_a', duration = 1000, flag = 49 },
    watch = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', duration = 900, flag = 49 },
    bracelet = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', duration = 900, flag = 49 },
    bag = { dict = 'anim@heists@ornate_bank@grab_cash', anim = 'intro', duration = 1100, flag = 49 },
    vest = { dict = 'clothingtie', anim = 'try_tie_neutral_d', duration = 1200, flag = 49 },
    jacket = { dict = 'clothingtie', anim = 'try_tie_negative_a', duration = 1300, flag = 49 },
    pants = { dict = 're@construction', anim = 'out_of_breath', duration = 1300, flag = 49 },
    shoes = { dict = 'random@domestic', anim = 'pickup_low', duration = 1200, flag = 49 }
}

Config.ClothingItems = {
    { id = 'hat', label = 'Gorra', icon = 'fa-brands fa-redhat', parts = { { type = 'prop', id = 0 } } },
    { id = 'mask', label = 'Máscara', icon = 'fa-solid fa-masks-theater', parts = { { type = 'component', id = 1 } } },
    { id = 'glasses', label = 'Lentes', icon = 'fa-solid fa-glasses', parts = { { type = 'prop', id = 1 } } },
    { id = 'ears', label = 'Oreja', icon = 'fa-solid fa-headphones', parts = { { type = 'prop', id = 2 } } },
    { id = 'chain', label = 'Bufanda', icon = 'fa-solid fa-ribbon', parts = { { type = 'component', id = 7 } } },
    { id = 'watch', label = 'Reloj', icon = 'fa-solid fa-clock', parts = { { type = 'prop', id = 6 } } },
    { id = 'bracelet', label = 'Pulsera', icon = 'fa-solid fa-drum-steelpan', parts = { { type = 'prop', id = 7 } } },
    { id = 'bag', label = 'Bolsa', icon = 'fa-solid fa-briefcase', parts = { { type = 'component', id = 5 } } },
    { id = 'vest', label = 'Chaleco', icon = 'fa-solid fa-vest', parts = { { type = 'component', id = 9 } } },
    { id = 'jacket', label = 'Playera', icon = 'fa-solid fa-shirt', parts = { { type = 'component', id = 11 }, { type = 'component', id = 8 } } },
    { id = 'pants', label = 'Pantalón', icon = 'fa-solid fa-person', parts = { { type = 'component', id = 4 } } },
    { id = 'shoes', label = 'Zapatos', icon = 'fa-solid fa-shoe-prints', parts = { { type = 'component', id = 6 } } }
}

Config.Defaults = {
    [0] = {
        components = {
            [1] = { drawable = 0, texture = 0, palette = 0 },
            [4] = { drawable = 61, texture = 1, palette = 0 },
            [5] = { drawable = 0, texture = 0, palette = 0 },
            [6] = { drawable = 128, texture = 0, palette = 0 },
            [7] = { drawable = 14, texture = 0, palette = 0 },
            [8] = { drawable = 15, texture = 0, palette = 0 },
            [9] = { drawable = 0, texture = 0, palette = 0 },
            [11] = { drawable = 25, texture = 0, palette = 0 }
        }
    },
    [1] = {
        components = {
            [1] = { drawable = 0, texture = 0, palette = 0 },
            [4] = { drawable = 15, texture = 0, palette = 0 },
            [5] = { drawable = 0, texture = 0, palette = 0 },
            [6] = { drawable = 35, texture = 0, palette = 0 },
            [7] = { drawable = 0, texture = 0, palette = 0 },
            [8] = { drawable = 15, texture = 0, palette = 0 },
            [9] = { drawable = 0, texture = 0, palette = 0 },
            [11] = { drawable = 15, texture = 0, palette = 0 }
        }
    }
}

-- Layout visual tipo diagrama del carro.
Config.VehicleOptions = {
    { id = 'hood', key = 'CO', label = 'Cofre', icon = 'fa-solid fa-car-burst', svg = 'icons/carhood.svg', action = 'vehicle_door', door = 4, slot = 'hood' },
    { id = 'seat_driver', key = 'A', label = 'Asiento conductor', icon = 'fa-solid fa-chair', svg = 'icons/carSeat.svg', action = 'vehicle_seat', seat = -1, slot = 'seat_driver' },
    { id = 'seat_passenger', key = 'A', label = 'Asiento copiloto', icon = 'fa-solid fa-chair', svg = 'icons/carSeat.svg', action = 'vehicle_seat', seat = 0, slot = 'seat_passenger' },
    { id = 'window_lf', key = 'V', label = 'Ventana delantera izquierda', icon = 'fa-regular fa-window-maximize', svg = 'icons/dooriconreverted.svg', action = 'vehicle_window', window = 0, slot = 'window_lf' },
    { id = 'door_lf', key = 'P', label = 'Puerta delantera izquierda', icon = 'fa-solid fa-door-open', svg = 'icons/cardoor.svg', action = 'vehicle_door', door = 0, slot = 'door_lf' },
    { id = 'door_rf', key = 'P', label = 'Puerta delantera derecha', icon = 'fa-solid fa-door-open', svg = 'icons/cardoor.svg', action = 'vehicle_door', door = 1, slot = 'door_rf' },
    { id = 'window_rf', key = 'V', label = 'Ventana delantera derecha', icon = 'fa-regular fa-window-maximize', svg = 'icons/dooriconreverted.svg', action = 'vehicle_window', window = 1, slot = 'window_rf' },
    { id = 'window_lr', key = 'V', label = 'Ventana trasera izquierda', icon = 'fa-regular fa-window-maximize', svg = 'icons/dooriconreverted.svg', action = 'vehicle_window', window = 2, slot = 'window_lr' },
    { id = 'door_lr', key = 'P', label = 'Puerta trasera izquierda', icon = 'fa-solid fa-door-open', svg = 'icons/cardoor.svg', action = 'vehicle_door', door = 2, slot = 'door_lr' },
    { id = 'door_rr', key = 'P', label = 'Puerta trasera derecha', icon = 'fa-solid fa-door-open', svg = 'icons/cardoor.svg', action = 'vehicle_door', door = 3, slot = 'door_rr' },
    { id = 'window_rr', key = 'V', label = 'Ventana trasera derecha', icon = 'fa-regular fa-window-maximize', svg = 'icons/dooriconreverted.svg', action = 'vehicle_window', window = 3, slot = 'window_rr' },
    { id = 'seat_rear_l', key = 'A', label = 'Asiento trasero izq.', icon = 'fa-solid fa-chair', svg = 'icons/carSeat.svg', action = 'vehicle_seat', seat = 1, slot = 'seat_rear_l' },
    { id = 'seat_rear_r', key = 'A', label = 'Asiento trasero der.', icon = 'fa-solid fa-chair', svg = 'icons/carSeat.svg', action = 'vehicle_seat', seat = 2, slot = 'seat_rear_r' },
    { id = 'trunk', key = 'C', label = 'Cajuela', icon = 'fa-solid fa-box-open', svg = 'icons/trunk.svg', action = 'vehicle_door', door = 5, slot = 'trunk' },
    { id = 'engine', key = 'M', label = 'Motor', icon = 'fa-solid fa-power-off', action = 'vehicle_engine', slot = 'engine' },
    { id = 'plate', key = 'P', label = 'Placa', icon = 'fa-solid fa-id-card', action = 'vehicle_plate', slot = 'plate' }
}

Config.Animations = {
    { id = 'arms', label = 'Cruzar brazos', icon = 'fa-solid fa-user', dict = 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', anim = 'idle_a', flag = 49 },
    { id = 'handsup', label = 'Manos arriba', icon = 'fa-solid fa-hands', dict = 'random@mugging3', anim = 'handsup_standing_base', flag = 49 },
    { id = 'kneel', label = 'Arrodillarse', icon = 'fa-solid fa-person-praying', dict = 'random@arrests', anim = 'kneeling_arrest_idle', flag = 1 },
    { id = 'notepad', label = 'Tomar notas', icon = 'fa-solid fa-clipboard', scenario = 'WORLD_HUMAN_CLIPBOARD' },
    { id = 'smoke', label = 'Fumar', icon = 'fa-solid fa-smoking', scenario = 'WORLD_HUMAN_SMOKING' },
    { id = 'sit', label = 'Sentarse', icon = 'fa-solid fa-chair', scenario = 'WORLD_HUMAN_PICNIC' },
    { id = 'mechanic', label = 'Revisar motor', icon = 'fa-solid fa-screwdriver-wrench', scenario = 'WORLD_HUMAN_VEHICLE_MECHANIC' },
    { id = 'cancel', label = 'Cancelar animación', icon = 'fa-solid fa-ban', action = 'clear_anim' }
}

Config.Documents = {
    { id = 'id', label = 'ID', icon = 'fa-solid fa-id-card', viewAction = 'view_id', showAction = 'show_id' },
    { id = 'driver', label = 'Licencia conducir', icon = 'fa-solid fa-car-side', viewAction = 'view_driver_license', showAction = 'show_driver_license' },
    { id = 'weapon', label = 'Licencia armas', icon = 'fa-solid fa-gun', viewAction = 'view_weapon_license', showAction = 'show_weapon_license' }
}


Config.DocumentDesigns = {
    id = {
        title = 'IDENTIFICACIÓN OFICIAL',
        typeLabel = 'INE DIGITAL',
        footer = 'R1 PERSONAL MENU • IDENTIFICACIÓN',
        extraTitle = '',
        extraFallback = 'Vigente'
    },
    driver = {
        title = 'LICENCIA DE CONDUCIR',
        typeLabel = 'TRÁNSITO / MOVILIDAD',
        footer = 'R1 PERSONAL MENU • LICENCIA DE CONDUCIR',
        licenseType = 'Tipo A - Automovilista',
        extraTitle = 'Tipo de licencia'
    },
    weapon = {
        title = 'LICENCIA DE ARMAS',
        typeLabel = 'REGISTRO DE ARMAS',
        footer = 'R1 PERSONAL MENU • LICENCIA DE ARMAS',
        licenseType = 'Portación civil registrada',
        extraTitle = 'Tipo de licencia'
    }
}

Config.DriverLicense = {
    defaultType = 'Tipo A - Automovilista',
    defaultStatus = 'Sin licencia',
    licenseTypes = {
        { label = 'Tipo A - Automovilista', value = 'Tipo A - Automovilista' },
        { label = 'Tipo B - Chofer particular', value = 'Tipo B - Chofer particular' },
        { label = 'Tipo C - Carga', value = 'Tipo C - Carga' },
        { label = 'Motociclista', value = 'Motociclista' }
    },
    statusOptions = {
        { label = 'Vigente', value = 'Vigente' },
        { label = 'Suspendida', value = 'Suspendida' },
        { label = 'Vencida', value = 'Vencida' }
    }
}

Config.DocumentPhoto = {
    command = 'finalizarine',
    key = 'H',
    control = 74, -- H
    quality = 0.72,
    timeout = 20000,
    defaultPhoto = 'img/default_photo.png'
}

Config.WeaponLicense = {
    enabled = true,

    -- Jobs que pueden abrir el punto de licencias.
    policeJobs = {
        police = true
    },

    -- Puntos donde el oficial puede solicitar la INE del ciudadano y tramitar licencia.
    points = {
        { coords = vector3(441.1686, -981.0341, 30.6896), radius = 2.0, label = 'Tramitar licencias' }
    },

    requestDistance = 3.0,
    requestTimeout = 15000,

    defaultType = 'Portación civil registrada',
    licenseTypes = {
        { label = 'Portación civil registrada', value = 'Portación civil registrada' },
        { label = 'Coleccionista', value = 'Coleccionista' },
        { label = 'Seguridad privada', value = 'Seguridad privada' }
    },

    statusOptions = {
        { label = 'Vigente', value = 'Vigente' },
        { label = 'Suspendida', value = 'Suspendida' },
        { label = 'Vencida', value = 'Vencida' }
    },

    -- Armas permitidas para registrar en la licencia.
    -- Si está en false, el oficial verá el arma pero no podrá registrarla.
    RegisterWeapons = {
        weapon_pistol = true,
        weapon_combatpistol = true,
        weapon_pistol50 = true,
        weapon_snspistol = true,
        weapon_carbinerifle = false,
        weapon_assaultrifle = false,
        weapon_mg = false
    }
}
