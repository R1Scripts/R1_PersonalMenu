const app = document.getElementById('app');
const shell = document.querySelector('.r1-shell');
const contentPanel = document.getElementById('contentPanel');
const navList = document.getElementById('navList');
const closeBtn = document.getElementById('closeBtn');
const menuTitle = document.getElementById('menuTitle');
const profileName = document.getElementById('profileName');
const profileJob = document.getElementById('profileJob');
const pageTitle = document.getElementById('pageTitle');
const pageDescription = document.getElementById('pageDescription');
const documentOverlay = document.getElementById('documentOverlay');
const closeDocFinger = document.getElementById('closeDocFinger');

let locale = {};

function t(key, fallback = '') {
    return locale[key] ?? fallback ?? key;
}

let state = {
    currentPage: null,
    pages: [],
    commands: [],
    clothingItems: [],
    clothingStates: {},
    vehicleOptions: [],
    vehicleStates: {},
    animations: [],
    documents: [],
    playerInfo: {}
};

function getPageMeta() {
    return {
        commands: [t('commands', 'Comandos'), t('commands_desc', 'Ejecuta comandos configurados del servidor.')],
        info: [t('info', 'Información personal'), t('info_desc', 'Datos del jugador, trabajo, dinero y estado.')],
        clothes: [t('clothes', 'Ropa'), t('clothes_desc', 'Quita y vuelve a poner prendas con animaciones.')],
        vehicle: [t('vehicle', 'Vehículo'), t('vehicle_desc', 'Control visual de puertas, ventanas, asientos y motor.')],
        animations: [t('animations', 'Animaciones'), t('animations_desc', 'Animaciones rápidas para roleplay.')],
        documents: [t('documents', 'Documentos'), t('documents_desc', 'INE, licencias y bases para registro.')]
    };
}

function post(eventName, data = {}) {
    fetch(`https://${GetParentResourceName()}/${eventName}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data)
    });
}

function money(value) {
    return `$${Number(value || 0).toLocaleString('en-US')}`;
}

function text(value, fallback = t('na', 'N/A')) {
    if (value === undefined || value === null || value === '') return fallback;
    return String(value);
}

function openPage(page) {
    state.currentPage = page;
    shell.classList.remove('menu-only');
    contentPanel.classList.remove('hidden-panel');
    contentPanel.classList.remove('slide-left');
    void contentPanel.offsetWidth;
    contentPanel.classList.add('slide-left');

    document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.toggle('active', btn.dataset.page === page));
    document.querySelectorAll('.page').forEach(sec => sec.classList.toggle('active', sec.id === `page-${page}`));

    const pageMeta = getPageMeta();
    const meta = pageMeta[page] || [t('r1_personal', 'R1 Personal'), ''];
    pageTitle.textContent = meta[0];
    pageDescription.textContent = meta[1];
}

function renderNav() {
    navList.innerHTML = '';
    state.pages.forEach(item => {
        const btn = document.createElement('button');
        btn.className = 'nav-btn';
        btn.dataset.page = item.page;
        btn.innerHTML = `<i class="${item.icon}"></i><span>${item.label}</span>`;
        btn.addEventListener('click', () => openPage(item.page));
        navList.appendChild(btn);
    });
}

function renderCommands() {
    const page = document.getElementById('page-commands');
    page.innerHTML = `<div class="icon-grid"></div>`;
    const grid = page.querySelector('.icon-grid');
    state.commands.forEach(cmd => {
        const card = document.createElement('button');
        card.className = 'icon-card';
        card.title = cmd.label;
        card.innerHTML = `<i class="fa-solid fa-terminal"></i><span>${cmd.label}</span>`;
        card.addEventListener('click', () => post('runAction', { action: 'command', command: cmd.command }));
        grid.appendChild(card);
    });
}

function renderInfo() {
    const p = state.playerInfo || {};
    profileName.textContent = text(p.name, t('player', 'Jugador'));
    profileJob.textContent = `${text(p.job, t('no_job', 'Sin trabajo'))} ${p.grade ? '- ' + p.grade : ''}`;

    const items = [
        ['fa-solid fa-user', t('name', 'Nombre'), text(p.name)],
        ['fa-solid fa-id-badge', t('id', 'ID'), text(p.serverId)],
        ['fa-solid fa-briefcase', t('job', 'Trabajo'), `${text(p.job)} ${p.grade ? '- ' + p.grade : ''}`],
        ['fa-solid fa-money-bill', t('cash', 'Efectivo'), money(p.money)],
        ['fa-solid fa-building-columns', t('bank', 'Banco'), money(p.bank)],
        ['fa-solid fa-cake-candles', t('date', 'Fecha'), text(p.birthdate)],
        ['fa-solid fa-ruler-vertical', t('height', 'Estatura'), p.height ? `${p.height} cm` : t('na', 'N/A')],
        ['fa-solid fa-venus-mars', t('sex', 'Sexo'), text(p.sex)],
        ['fa-solid fa-heart-pulse', t('health', 'Vida'), `${text(p.health, 0)}%`],
        ['fa-solid fa-shield-halved', t('armor', 'Chaleco'), `${text(p.armor, 0)}%`]
    ];

    const page = document.getElementById('page-info');
    page.innerHTML = `<div class="info-grid"></div>`;
    const grid = page.querySelector('.info-grid');
    items.forEach(([icon, label, value]) => {
        const div = document.createElement('div');
        div.className = 'info-item';
        div.innerHTML = `<i class="${icon}"></i><div><b>${label}</b><span>${value}</span></div>`;
        grid.appendChild(div);
    });
}

function renderClothes() {
    const page = document.getElementById('page-clothes');
    page.innerHTML = `<div class="icon-grid clothes-grid"></div>`;
    const grid = page.querySelector('.icon-grid');
    state.clothingItems.forEach(item => {
        const removed = state.clothingStates[item.id] === true;
        const card = document.createElement('button');
        card.className = `icon-card only-icon ${removed ? 'active-red' : ''}`;
        card.title = item.label;
        card.dataset.id = item.id;
        card.innerHTML = `<i class="${item.icon}"></i><small>${removed ? t('put', 'Poner') : t('remove', 'Quitar')}</small>`;
        card.addEventListener('click', () => post('toggleClothing', { id: item.id }));
        grid.appendChild(card);
    });
}

function renderVehicle() {
    const page = document.getElementById('page-vehicle');
    page.innerHTML = `
        <div class="vehicle-map">
            <div class="veh-btn" data-slot="hood"></div>
            <div class="veh-btn" data-slot="seat_driver"></div>
            <div class="veh-btn" data-slot="seat_passenger"></div>
            <div class="veh-btn" data-slot="window_lf"></div>
            <div class="veh-btn" data-slot="door_lf"></div>
            <div class="veh-btn" data-slot="door_rf"></div>
            <div class="veh-btn" data-slot="window_rf"></div>
            <div class="veh-btn" data-slot="window_lr"></div>
            <div class="veh-btn" data-slot="door_lr"></div>
            <div class="veh-btn" data-slot="door_rr"></div>
            <div class="veh-btn" data-slot="window_rr"></div>
            <div class="veh-btn" data-slot="seat_rear_l"></div>
            <div class="veh-btn" data-slot="seat_rear_r"></div>
            <div class="veh-btn" data-slot="trunk"></div>
            <div class="veh-btn" data-slot="engine"></div>
            <div class="veh-btn" data-slot="plate"></div>
        </div>
    `;

    state.vehicleOptions.forEach(opt => {
        const el = page.querySelector(`[data-slot="${opt.slot}"]`);
        if (!el) return;
        const active = state.vehicleStates[opt.id] === true;
        const neutral = opt.action === 'vehicle_plate';
        el.classList.toggle('active-yellow', neutral);
        el.classList.toggle('active-red', !neutral && active);
        el.classList.toggle('active-green', !neutral && !active);
        el.title = opt.label;
        if (opt.svg) {
            el.innerHTML = `<img class="veh-svg" src="${opt.svg}" alt="${opt.label || ''}"><em></em>`;
        } else {
            el.innerHTML = `<i class="${opt.icon || 'fa-solid fa-circle'}"></i><em></em>`;
        }
        el.addEventListener('click', () => post('runAction', opt));
    });
}

function renderAnimations() {
    const page = document.getElementById('page-animations');
    page.innerHTML = `<div class="icon-grid"></div>`;
    const grid = page.querySelector('.icon-grid');
    state.animations.forEach(anim => {
        const card = document.createElement('button');
        card.className = 'icon-card only-icon';
        card.title = anim.label;
        card.innerHTML = `<i class="${anim.icon}"></i><small>${anim.label}</small>`;
        card.addEventListener('click', () => post('playAnimation', anim));
        grid.appendChild(card);
    });
}

function renderDocuments() {
    const page = document.getElementById('page-documents');
    page.innerHTML = `<div class="doc-grid"></div><div class="doc-note">${t('doc_note', 'Para guardar tu foto usa /finalizarine. Se abrirá cámara frontal y presionas H para tomarla.')}</div>`;
    const grid = page.querySelector('.doc-grid');

    state.documents.forEach(doc => {
        const card = document.createElement('div');
        card.className = 'doc-menu-card';
        card.innerHTML = `
            <button class="doc-main-btn" type="button">
                <i class="${doc.icon}"></i>
                <span>${doc.label}</span>
                <small>${t('click_options', 'Click para ver opciones')}</small>
            </button>
            <div class="doc-actions">
                <button type="button" data-mode="view"><i class="fa-solid fa-eye"></i> ${t('view', 'Ver')}</button>
                <button type="button" data-mode="show"><i class="fa-solid fa-share"></i> ${t('show', 'Enseñar')}</button>
            </div>
        `;

        card.querySelector('.doc-main-btn').addEventListener('click', () => {
            card.classList.toggle('open');
        });

        card.querySelectorAll('.doc-actions button').forEach(btn => {
            btn.addEventListener('click', () => {
                post('runAction', { action: btn.dataset.mode === 'show' ? doc.showAction : doc.viewAction });
            });
        });

        grid.appendChild(card);
    });
}

function renderAll() {
    renderNav();
    renderCommands();
    renderInfo();
    renderClothes();
    renderVehicle();
    renderAnimations();
    renderDocuments();
}

function updateClothingItem(id, removed) {
    state.clothingStates[id] = removed;
    renderClothes();
}

function updateVehicleStates(states) {
    state.vehicleStates = states || {};
    renderVehicle();
}

function setDocField(id, label, value, visible = true, wide = false) {
    const el = document.getElementById(id);
    if (!el) return;
    const wrap = el.closest('div');
    if (!wrap) return;
    wrap.style.display = visible ? '' : 'none';
    wrap.classList.toggle('wide', wide === true);
    const b = wrap.querySelector('b');
    if (b) b.textContent = label;
    el.textContent = text(value);
}

function openDocument(doc) {
    const docType = doc.type || 'id';
    const card = document.getElementById('docCard');
    card.className = `ine-card doc-${docType}`;

    const topStatus = text(doc.topStatus || doc.status, docType === 'id' ? t('valid', 'VIGENTE') : t('no_license', 'SIN LICENCIA'));
    const identifierText = text(doc.identifier || doc.key, 'N/A');
    const topLine = `${topStatus.toUpperCase()}: ${identifierText}`;

    document.getElementById('docTypeLabel').textContent = text(doc.typeLabel, docType === 'driver' ? t('driver_type', 'TRÁNSITO / MOVILIDAD') : docType === 'weapon' ? t('weapon_type', 'REGISTRO DE ARMAS') : t('ine_digital', 'INE DIGITAL'));
    document.getElementById('docTitle').textContent = text(doc.title, docType === 'driver' ? t('driver_title', 'LICENCIA DE CONDUCIR') : docType === 'weapon' ? t('weapon_title', 'LICENCIA DE ARMAS') : t('id_title', 'IDENTIFICACIÓN OFICIAL'));
    document.getElementById('docServer').textContent = topLine;
    document.getElementById('docServer').className = topStatus.toLowerCase().includes('vigente') ? 'doc-status-ok' : 'doc-status-bad';

    setDocField('docName', t('name', 'Nombre'), doc.name, true);
    setDocField('docAge', t('age', 'Edad'), doc.age, true);
    setDocField('docBirthdate', t('birthdate', 'Fecha nacimiento'), doc.birthdate, docType === 'id');
    setDocField('docHeight', t('height', 'Estatura'), doc.height ? `${doc.height} cm` : t('na', 'N/A'), true);
    setDocField('docSex', t('sex', 'Sexo'), doc.sex, docType !== 'weapon');
    setDocField('docNationality', t('nationality', 'Nacionalidad'), doc.nationality, docType === 'id');

    if (docType === 'id') {
        setDocField('docExtraValue', '', '', false);
        setDocField('docStatus', '', '', false);
        setDocField('docIssued', '', '', false);
        setDocField('docKey', '', '', false);
    } else if (docType === 'driver') {
        setDocField('docExtraValue', t('license_type', 'Tipo licencia'), doc.extraValue || doc.licenseType || t('no_license', 'Sin licencia'), true);
        setDocField('docStatus', t('issued', 'Expedición'), doc.issuedAt || t('na', 'N/A'), true);
        setDocField('docIssued', '', '', false);
    } else if (docType === 'weapon') {
        setDocField('docExtraValue', t('license_type', 'Tipo licencia'), doc.extraValue || doc.licenseType || t('no_license', 'Sin licencia'), true);
        setDocField('docStatus', t('issued', 'Expedición'), doc.issuedAt || t('na', 'N/A'), true);
        setDocField('docIssued', t('weapon', 'Arma'), doc.weaponSerial || t('no_weapon_registered', 'SIN ARMA REGISTRADA'), true);
    }

    document.getElementById('docFooter').textContent = text(doc.footer, t('footer', 'R1 PERSONAL MENU • DOCUMENTOS'));

    const photo = document.getElementById('docPhoto');
    if (doc.photo && (String(doc.photo).startsWith('http') || String(doc.photo).startsWith('data:image') || String(doc.photo).startsWith('img/'))) {
        photo.innerHTML = `<img src="${doc.photo}" alt="${t('photo', 'Foto')}">`;
    } else {
        photo.innerHTML = `<i class="fa-solid fa-user"></i>`;
    }

    documentOverlay.classList.remove('hidden');
}

window.addEventListener('message', (event) => {
    const data = event.data || {};

    if (data.action === 'open') {
        locale = data.locales || locale || {};
        document.documentElement.lang = (locale.commands === 'Commands') ? 'en' : 'es';
        document.getElementById('pageEyebrow').textContent = t('r1_personal', 'R1 PERSONAL');
        document.getElementById('profileName').textContent = t('player', 'Jugador');
        document.getElementById('profileJob').textContent = t('loading', 'Cargando...');
        state = {
            ...state,
            pages: data.pages || [],
            commands: data.commands || [],
            clothingItems: data.clothingItems || [],
            clothingStates: data.clothingStates || {},
            vehicleOptions: data.vehicleOptions || [],
            vehicleStates: data.vehicleStates || {},
            animations: data.animations || [],
            documents: data.documents || [],
            playerInfo: data.playerInfo || {}
        };
        menuTitle.textContent = data.title || 'R1 PERSONAL MENU';
        app.classList.remove('hidden');
        shell.classList.add('menu-only');
        contentPanel.classList.add('hidden-panel');
        renderAll();
    }

    if (data.action === 'close') app.classList.add('hidden');
    if (data.action === 'updateClothingItem') updateClothingItem(data.id, data.removed);
    if (data.action === 'vehicleStates') updateVehicleStates(data.states);
    if (data.action === 'openDocument') openDocument(data.document || {});
    if (data.action === 'closeDocument') documentOverlay.classList.add('hidden');
});

closeBtn.addEventListener('click', () => post('close'));
closeDocFinger.addEventListener('click', () => post('closeDocument'));
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        if (!documentOverlay.classList.contains('hidden')) post('closeDocument');
        else post('close');
    }
});
