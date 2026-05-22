Config.Locale = Config.Locale or 'es' -- 'es' o 'en'

Locales = Locales or {}

Locales.es = {
    menu_title = 'R1 PERSONAL MENU',
    interact = 'Interactuar',
    open_personal_menu = 'Abrir R1 Personal Menu',
    no_permission_point = 'No tienes permiso para usar este punto.',
    no_permission_licenses = 'No tienes permiso para tramitar licencias.',
    no_permission = 'No tienes permiso.',
    missing_ox_form = 'Falta ox_lib para abrir el formulario.',
    missing_ox_panel = 'Falta ox_lib para abrir el panel.',
    licenses = 'Licencias',
    issue_licenses = 'Tramitar licencias',
    weapon_license = 'Licencia de armas',
    driver_license = 'Licencia de conducir',
    weapon_license_desc = 'Solicitar ID, validar inventario y registrar armas permitidas.',
    driver_license_desc = 'Solicitar ID y emitir/actualizar licencia de conducir.',
    issue_weapon_license = 'Emitir licencia de armas',
    license_type = 'Tipo de licencia',
    status = 'Estado',
    citizen = 'Ciudadano',
    citizen_desc = 'ID: %s | Edad: %s | Estatura: %s | Sexo: %s',
    view_citizen_id = 'Ver INE del ciudadano',
    view_citizen_id_desc = 'Abre la identificación que el ciudadano autorizó mostrar.',
    issue_update_driver = 'Emitir / actualizar licencia de conducir',
    issue_update_driver_desc = 'Selecciona tipo de licencia y estado.',
    issue_update_license = 'Emitir / actualizar licencia',
    issue_update_license_desc = 'Crea o actualiza la licencia de armas del ciudadano.',
    inventory_weapons = 'Armas encontradas en inventario',
    no_weapons = 'Sin armas detectadas',
    no_weapons_desc = 'El jugador no trae armas registrables en inventario.',
    serial = 'Serial: %s',
    no_serial = 'SIN SERIAL',
    already_registered = 'YA REGISTRADA',
    not_allowed = 'NO PERMITIDA',
    ready_register = 'Lista para registrar',
    clothes = 'Ropa',
    nothing_to_remove = 'No tienes nada para quitar aquí.',
    vehicle = 'Vehículo',
    no_vehicle_near = 'No hay vehículo cerca.',
    engine_off = 'Motor apagado.',
    engine_on = 'Motor encendido.',
    must_be_in_vehicle = 'Debes estar dentro de un vehículo.',
    seat_occupied = 'Ese asiento está ocupado.',
    plate = 'Placa',
    ine = 'INE',
    screenshot_missing = 'Falta iniciar screenshot-basic en el server.cfg.',
    camera_ready = 'Cámara lista. Presiona %s para tomar la foto o ESC para cancelar.',
    photo_cancelled = 'Foto cancelada.',
    photo_failed = 'No se pudo tomar la foto.',
    photo_timeout = 'Tiempo agotado para tomar la foto.',
    officer_request_id = 'El oficial %s solicita ver tu INE. Presiona E para mostrarla.',
    show_id_officer = 'Mostrar INE al oficial',
    request_cancelled = 'Solicitud cancelada.',
    request_expired = 'La solicitud expiró.',
    show_id_driver = 'Mostrar INE para licencia conducir',
    driver_request_expired = 'Solicitud de licencia vencida.',
    open_weapon_licenses = 'Abrir licencias de armas',
    no_identifier = 'No se pudo detectar tu identificador.',
    empty_photo = 'La foto llegó vacía.',
    photo_saved = 'Foto guardada correctamente.',
    no_players_near = 'No hay jugadores cerca.',
    showed_id_nearby = 'Mostraste tu ID al jugador cercano.',
    no_citizens_near = 'No hay ciudadanos cerca.',
    request_sent_citizen = 'Solicitud enviada al ciudadano cercano.',
    invalid_request = 'La solicitud ya no es válida.',
    player_not_connected = 'El jugador no está conectado.',
    driver_license_given = 'Licencia de conducir entregada correctamente.',
    driver_license_received = 'Recibiste una licencia de conducir.',
    no_citizens_id_near = 'No hay ciudadanos cerca para solicitar INE.',
    request_sent_wait_ine = 'Solicitud enviada. Espera a que el ciudadano muestre su INE.',
    officer_offline = 'El oficial ya no está conectado.',
    officer_no_permission = 'El oficial ya no tiene permiso.',
    showed_id_officer = 'Mostraste tu INE al oficial.',
    no_permission_give_licenses = 'No tienes permiso para entregar licencias.',
    no_player_identifier = 'No se pudo obtener el identificador del jugador.',
    weapon_license_updated = 'Licencia de armas emitida/actualizada.',
    weapon_license_received_update = 'Tu licencia de armas fue actualizada.',
    no_permission_register_weapons = 'No tienes permiso para registrar armas.',
    weapon_not_found = 'El arma ya no está en el inventario o no coincide.',
    weapon_not_allowed = 'Esta arma no está permitida para registro. Debe retenerse según tu rol.',
    weapon_no_serial = 'Esta arma no tiene serial. Se considera ilegal/no registrable.',
    weapon_already_registered = 'Esta arma ya está registrada.',
    weapon_registered = 'Arma registrada: %s | Serial: %s',
    weapon_registered_target = 'Registraron tu arma: %s',
    weapon_license_given = 'Licencia de armas entregada correctamente.',
    weapon_license_received = 'Recibiste una licencia de armas.',
    no_job = 'Sin trabajo',
    standalone = 'Standalone',
    male = 'Masculino',
    female = 'Femenino',
    valid = 'Vigente',
    suspended = 'Suspendida',
    expired = 'Vencida',
    no_license = 'Sin licencia',
    registered = 'Registrada',
    driver_type_a = 'Tipo A - Automovilista',
    driver_type_b = 'Tipo B - Chofer particular',
    driver_type_c = 'Tipo C - Carga',
    driver_type_motorcycle = 'Motociclista',
    weapon_type_civil = 'Portación civil registrada',
    weapon_type_collector = 'Coleccionista',
    weapon_type_security = 'Seguridad privada',
    document_id_title = 'IDENTIFICACIÓN OFICIAL',
    document_id_type = 'INE DIGITAL',
    document_id_footer = 'R1 PERSONAL MENU • IDENTIFICACIÓN',
    document_driver_title = 'LICENCIA DE CONDUCIR',
    document_driver_type = 'TRÁNSITO / MOVILIDAD',
    document_driver_footer = 'R1 PERSONAL MENU • LICENCIA DE CONDUCIR',
    document_weapon_title = 'LICENCIA DE ARMAS',
    document_weapon_type = 'REGISTRO DE ARMAS',
    document_weapon_footer = 'R1 PERSONAL MENU • LICENCIA DE ARMAS',
    nui = {
        player = 'Jugador', loading = 'Cargando...', na = 'N/A', no_job = 'Sin trabajo', r1_personal = 'R1 PERSONAL',
        commands = 'Comandos', commands_desc = 'Ejecuta comandos configurados del servidor.',
        info = 'Información personal', info_desc = 'Datos del jugador, trabajo, dinero y estado.',
        clothes = 'Ropa', clothes_desc = 'Quita y vuelve a poner prendas con animaciones.',
        vehicle = 'Vehículo', vehicle_desc = 'Control visual de puertas, ventanas, asientos y motor.',
        animations = 'Animaciones', animations_desc = 'Animaciones rápidas para roleplay.',
        documents = 'Documentos', documents_desc = 'INE, licencias y bases para registro.',
        name = 'Nombre', age = 'Edad', id = 'ID', job = 'Trabajo', cash = 'Efectivo', bank = 'Banco', date = 'Fecha', height = 'Estatura', sex = 'Sexo', health = 'Vida', armor = 'Chaleco',
        put = 'Poner', remove = 'Quitar', doc_note = 'Para guardar tu foto usa /finalizarine. Se abrirá cámara frontal y presionas H para tomarla.', click_options = 'Click para ver opciones', view = 'Ver', show = 'Enseñar',
        valid = 'VIGENTE', no_license = 'SIN LICENCIA', driver_type = 'TRÁNSITO / MOVILIDAD', weapon_type = 'REGISTRO DE ARMAS', ine_digital = 'INE DIGITAL',
        id_title = 'IDENTIFICACIÓN OFICIAL', driver_title = 'LICENCIA DE CONDUCIR', weapon_title = 'LICENCIA DE ARMAS', birthdate = 'Fecha nacimiento', nationality = 'Nacionalidad', key = 'Clave', status = 'Estado', issued = 'Expedición', license_type = 'Tipo licencia', weapon = 'Arma', no_weapon_registered = 'SIN ARMA REGISTRADA', footer = 'R1 PERSONAL MENU • DOCUMENTOS', photo = 'Foto'
    }
}

Locales.en = {
    menu_title = 'R1 PERSONAL MENU',
    interact = 'Interact',
    open_personal_menu = 'Open R1 Personal Menu',
    no_permission_point = 'You do not have permission to use this point.',
    no_permission_licenses = 'You do not have permission to process licenses.',
    no_permission = 'You do not have permission.',
    missing_ox_form = 'ox_lib is required to open the form.',
    missing_ox_panel = 'ox_lib is required to open the panel.',
    licenses = 'Licenses',
    issue_licenses = 'Process licenses',
    weapon_license = 'Weapon license',
    driver_license = 'Driver license',
    weapon_license_desc = 'Request ID, validate inventory and register allowed weapons.',
    driver_license_desc = 'Request ID and issue/update a driver license.',
    issue_weapon_license = 'Issue weapon license',
    license_type = 'License type',
    status = 'Status',
    citizen = 'Citizen',
    citizen_desc = 'ID: %s | Age: %s | Height: %s | Sex: %s',
    view_citizen_id = 'View citizen ID',
    view_citizen_id_desc = 'Open the ID the citizen authorized to show.',
    issue_update_driver = 'Issue / update driver license',
    issue_update_driver_desc = 'Select license type and status.',
    issue_update_license = 'Issue / update license',
    issue_update_license_desc = 'Create or update the citizen weapon license.',
    inventory_weapons = 'Weapons found in inventory',
    no_weapons = 'No weapons detected',
    no_weapons_desc = 'The player has no registerable weapons in inventory.',
    serial = 'Serial: %s',
    no_serial = 'NO SERIAL',
    already_registered = 'ALREADY REGISTERED',
    not_allowed = 'NOT ALLOWED',
    ready_register = 'Ready to register',
    clothes = 'Clothes',
    nothing_to_remove = 'You have nothing to remove here.',
    vehicle = 'Vehicle',
    no_vehicle_near = 'There is no vehicle nearby.',
    engine_off = 'Engine turned off.',
    engine_on = 'Engine turned on.',
    must_be_in_vehicle = 'You must be inside a vehicle.',
    seat_occupied = 'That seat is occupied.',
    plate = 'Plate',
    ine = 'ID',
    screenshot_missing = 'screenshot-basic must be started in server.cfg.',
    camera_ready = 'Camera ready. Press %s to take the photo or ESC to cancel.',
    photo_cancelled = 'Photo cancelled.',
    photo_failed = 'Could not take the photo.',
    photo_timeout = 'Time expired to take the photo.',
    officer_request_id = 'Officer %s requests to see your ID. Press E to show it.',
    show_id_officer = 'Show ID to officer',
    request_cancelled = 'Request cancelled.',
    request_expired = 'The request expired.',
    show_id_driver = 'Show ID for driver license',
    driver_request_expired = 'License request expired.',
    open_weapon_licenses = 'Open weapon licenses',
    no_identifier = 'Could not detect your identifier.',
    empty_photo = 'The photo was empty.',
    photo_saved = 'Photo saved successfully.',
    no_players_near = 'There are no players nearby.',
    showed_id_nearby = 'You showed your ID to the nearby player.',
    no_citizens_near = 'There are no citizens nearby.',
    request_sent_citizen = 'Request sent to nearby citizen.',
    invalid_request = 'The request is no longer valid.',
    player_not_connected = 'The player is not connected.',
    driver_license_given = 'Driver license delivered successfully.',
    driver_license_received = 'You received a driver license.',
    no_citizens_id_near = 'There are no citizens nearby to request ID.',
    request_sent_wait_ine = 'Request sent. Wait for the citizen to show their ID.',
    officer_offline = 'The officer is no longer connected.',
    officer_no_permission = 'The officer no longer has permission.',
    showed_id_officer = 'You showed your ID to the officer.',
    no_permission_give_licenses = 'You do not have permission to deliver licenses.',
    no_player_identifier = 'Could not get the player identifier.',
    weapon_license_updated = 'Weapon license issued/updated.',
    weapon_license_received_update = 'Your weapon license was updated.',
    no_permission_register_weapons = 'You do not have permission to register weapons.',
    weapon_not_found = 'The weapon is no longer in inventory or does not match.',
    weapon_not_allowed = 'This weapon is not allowed for registration. It must be retained according to your role.',
    weapon_no_serial = 'This weapon has no serial. It is considered illegal/not registerable.',
    weapon_already_registered = 'This weapon is already registered.',
    weapon_registered = 'Weapon registered: %s | Serial: %s',
    weapon_registered_target = 'Your weapon was registered: %s',
    weapon_license_given = 'Weapon license delivered successfully.',
    weapon_license_received = 'You received a weapon license.',
    no_job = 'No job',
    standalone = 'Standalone',
    male = 'Male',
    female = 'Female',
    valid = 'Valid',
    suspended = 'Suspended',
    expired = 'Expired',
    no_license = 'No license',
    registered = 'Registered',
    driver_type_a = 'Type A - Driver',
    driver_type_b = 'Type B - Private chauffeur',
    driver_type_c = 'Type C - Cargo',
    driver_type_motorcycle = 'Motorcyclist',
    weapon_type_civil = 'Registered civilian carry',
    weapon_type_collector = 'Collector',
    weapon_type_security = 'Private security',
    document_id_title = 'OFFICIAL IDENTIFICATION',
    document_id_type = 'DIGITAL ID',
    document_id_footer = 'R1 PERSONAL MENU • IDENTIFICATION',
    document_driver_title = 'DRIVER LICENSE',
    document_driver_type = 'TRAFFIC / MOBILITY',
    document_driver_footer = 'R1 PERSONAL MENU • DRIVER LICENSE',
    document_weapon_title = 'WEAPON LICENSE',
    document_weapon_type = 'WEAPON REGISTRY',
    document_weapon_footer = 'R1 PERSONAL MENU • WEAPON LICENSE',
    nui = {
        player = 'Player', loading = 'Loading...', na = 'N/A', no_job = 'No job', r1_personal = 'R1 PERSONAL',
        commands = 'Commands', commands_desc = 'Run configurable server commands.',
        info = 'Personal information', info_desc = 'Player data, job, money and status.',
        clothes = 'Clothes', clothes_desc = 'Remove and put clothing items back with animations.',
        vehicle = 'Vehicle', vehicle_desc = 'Visual control for doors, windows, seats and engine.',
        animations = 'Animations', animations_desc = 'Quick roleplay animations.',
        documents = 'Documents', documents_desc = 'ID, licenses and registry documents.',
        name = 'Name', age = 'Age', id = 'ID', job = 'Job', cash = 'Cash', bank = 'Bank', date = 'Date', height = 'Height', sex = 'Sex', health = 'Health', armor = 'Armor',
        put = 'Put on', remove = 'Remove', doc_note = 'To save your photo use /finalizarine. The front camera will open and you press H to take it.', click_options = 'Click to see options', view = 'View', show = 'Show',
        valid = 'VALID', no_license = 'NO LICENSE', driver_type = 'TRAFFIC / MOBILITY', weapon_type = 'WEAPON REGISTRY', ine_digital = 'DIGITAL ID',
        id_title = 'OFFICIAL IDENTIFICATION', driver_title = 'DRIVER LICENSE', weapon_title = 'WEAPON LICENSE', birthdate = 'Birthdate', nationality = 'Nationality', key = 'Key', status = 'Status', issued = 'Issued', license_type = 'License type', weapon = 'Weapon', no_weapon_registered = 'NO REGISTERED WEAPON', footer = 'R1 PERSONAL MENU • DOCUMENTS', photo = 'Photo'
    }
}

local function GetLocaleTable()
    local locale = Config.Locale or 'es'
    return Locales[locale] or Locales.es or {}
end

function _U(key, ...)
    local localeTable = GetLocaleTable()
    local value = localeTable[key]

    if value == nil and Locales.es then value = Locales.es[key] end
    if value == nil then value = key end

    if select('#', ...) > 0 and type(value) == 'string' then
        return value:format(...)
    end

    return value
end

local function SetLabelByKey(list, keyName, keyValue, label)
    if not list then return end
    for _, item in pairs(list) do
        if item[keyName] == keyValue then
            item.label = label
            return
        end
    end
end

function R1_ApplyLocalesToConfig()
    Config.MenuTitle = _U('menu_title')

    local commandLabels = {
        carradio = 'Car Radio', reloadskin = Config.Locale == 'en' and 'Reload Ped' or 'Reiniciar Ped', hud = 'HUD', report = Config.Locale == 'en' and 'Report' or 'Reporte'
    }
    for _, item in pairs(Config.Commands or {}) do if commandLabels[item.command] then item.label = commandLabels[item.command] end end

    local pages = { commands = _U('nui').commands, info = _U('nui').info, clothes = _U('nui').clothes, vehicle = _U('nui').vehicle, animations = _U('nui').animations, documents = _U('nui').documents }
    for id, label in pairs(pages) do SetLabelByKey(Config.Pages, 'page', id, label) end

    local clothes = Config.Locale == 'en' and { hat='Hat', mask='Mask', glasses='Glasses', ears='Ears', chain='Scarf', watch='Watch', bracelet='Bracelet', bag='Bag', vest='Vest', jacket='Shirt', pants='Pants', shoes='Shoes' } or { hat='Gorra', mask='Máscara', glasses='Lentes', ears='Oreja', chain='Bufanda', watch='Reloj', bracelet='Pulsera', bag='Bolsa', vest='Chaleco', jacket='Playera', pants='Pantalón', shoes='Zapatos' }
    for id, label in pairs(clothes) do SetLabelByKey(Config.ClothingItems, 'id', id, label) end

    local vehicles = Config.Locale == 'en' and {
        hood='Hood', seat_driver='Driver seat', seat_passenger='Passenger seat', window_lf='Front left window', door_lf='Front left door', door_rf='Front right door', window_rf='Front right window', window_lr='Rear left window', door_lr='Rear left door', door_rr='Rear right door', window_rr='Rear right window', seat_rear_l='Rear left seat', seat_rear_r='Rear right seat', trunk='Trunk', engine='Engine', plate='Plate'
    } or {
        hood='Cofre', seat_driver='Asiento conductor', seat_passenger='Asiento copiloto', window_lf='Ventana delantera izquierda', door_lf='Puerta delantera izquierda', door_rf='Puerta delantera derecha', window_rf='Ventana delantera derecha', window_lr='Ventana trasera izquierda', door_lr='Puerta trasera izquierda', door_rr='Puerta trasera derecha', window_rr='Ventana trasera derecha', seat_rear_l='Asiento trasero izq.', seat_rear_r='Asiento trasero der.', trunk='Cajuela', engine='Motor', plate='Placa'
    }
    for id, label in pairs(vehicles) do SetLabelByKey(Config.VehicleOptions, 'id', id, label) end

    local anims = Config.Locale == 'en' and { arms='Cross arms', handsup='Hands up', kneel='Kneel', notepad='Take notes', smoke='Smoke', sit='Sit down', mechanic='Check engine', cancel='Cancel animation' } or { arms='Cruzar brazos', handsup='Manos arriba', kneel='Arrodillarse', notepad='Tomar notas', smoke='Fumar', sit='Sentarse', mechanic='Revisar motor', cancel='Cancelar animación' }
    for id, label in pairs(anims) do SetLabelByKey(Config.Animations, 'id', id, label) end

    local docs = Config.Locale == 'en' and { id='ID', driver='Driver license', weapon='Weapon license' } or { id='ID', driver='Licencia conducir', weapon='Licencia armas' }
    for id, label in pairs(docs) do SetLabelByKey(Config.Documents, 'id', id, label) end

    if Config.DocumentDesigns then
        if Config.DocumentDesigns.id then Config.DocumentDesigns.id.title = _U('document_id_title'); Config.DocumentDesigns.id.typeLabel = _U('document_id_type'); Config.DocumentDesigns.id.footer = _U('document_id_footer'); Config.DocumentDesigns.id.extraFallback = _U('valid') end
        if Config.DocumentDesigns.driver then Config.DocumentDesigns.driver.title = _U('document_driver_title'); Config.DocumentDesigns.driver.typeLabel = _U('document_driver_type'); Config.DocumentDesigns.driver.footer = _U('document_driver_footer'); Config.DocumentDesigns.driver.licenseType = _U('driver_type_a'); Config.DocumentDesigns.driver.extraTitle = _U('license_type') end
        if Config.DocumentDesigns.weapon then Config.DocumentDesigns.weapon.title = _U('document_weapon_title'); Config.DocumentDesigns.weapon.typeLabel = _U('document_weapon_type'); Config.DocumentDesigns.weapon.footer = _U('document_weapon_footer'); Config.DocumentDesigns.weapon.licenseType = _U('weapon_type_civil'); Config.DocumentDesigns.weapon.extraTitle = _U('license_type') end
    end

    if Config.DriverLicense then
        Config.DriverLicense.defaultStatus = _U('no_license')
        if Config.DriverLicense.licenseTypes then
            local labels = { _U('driver_type_a'), _U('driver_type_b'), _U('driver_type_c'), _U('driver_type_motorcycle') }
            for i, label in ipairs(labels) do if Config.DriverLicense.licenseTypes[i] then Config.DriverLicense.licenseTypes[i].label = label end end
        end
        if Config.DriverLicense.statusOptions then
            local labels = { _U('valid'), _U('suspended'), _U('expired') }
            for i, label in ipairs(labels) do if Config.DriverLicense.statusOptions[i] then Config.DriverLicense.statusOptions[i].label = label end end
        end
    end

    if Config.WeaponLicense then
        if Config.WeaponLicense.points then for _, point in pairs(Config.WeaponLicense.points) do point.label = _U('issue_licenses') end end
        if Config.WeaponLicense.licenseTypes then
            local labels = { _U('weapon_type_civil'), _U('weapon_type_collector'), _U('weapon_type_security') }
            for i, label in ipairs(labels) do if Config.WeaponLicense.licenseTypes[i] then Config.WeaponLicense.licenseTypes[i].label = label end end
        end
        if Config.WeaponLicense.statusOptions then
            local labels = { _U('valid'), _U('suspended'), _U('expired') }
            for i, label in ipairs(labels) do if Config.WeaponLicense.statusOptions[i] then Config.WeaponLicense.statusOptions[i].label = label end end
        end
    end

    Config.NuiLocales = _U('nui')
end

R1_ApplyLocalesToConfig()
