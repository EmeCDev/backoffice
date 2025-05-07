const BASE_PATH = "/"

export const PUBLIC_ROUTES = {
    BASE: {
        NAME: 'NA',
        MODULE: 'NA',
        FULL_PATH: BASE_PATH
    },
    LOGIN: {
        NAME: 'INICIO SESIÓN',
        MODULE: 'AUTENTICACION',
        FULL_PATH: BASE_PATH + 'iniciar-sesion'
    },
}

export const PROTECTED_ROUTES = {
    PORTAL: {
        NAME: 'PORTAL',
        MODULE: 'PORTAL',
        FULL_PATH: BASE_PATH
    },
    HOME: {
        NAME: 'INICIO',
        MODULE: 'PORTAL',
        FULL_PATH: BASE_PATH + 'inicio'
    },
    ZK_COMPANIES: {
        NAME: 'EMPRESAS',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/empresas'
    },
    ZK_DEVICES: {
        NAME: 'EQUIPOS',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/equipos'
    },
    ZK_SEND_USER: {
        NAME: 'CARGA ADMINISTRADOR',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/enviar-usuario'
    },
    ZK_BULK_ACCESS_UPLOAD: {
        NAME: 'CARGA MASIVA ACCESO',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/carga-masiva-acceso'
    },
    ZK_SEND_USER_RP: {
        NAME: 'CARGA ADMINISTRADOR RIPLEY',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/enviar-usuario-rp'
    },
    ZK_BULK_ACCESS_UPLOAD_RP: {
        NAME: 'CARGA MASIVA ACCESO RIPLEY',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/carga-masiva-acceso-rp'
    },
    ZK_SEND_USER_AD: {
        NAME: 'CARGA ADMINISTRADOR ARCOS DORADOS',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/enviar-usuario-ad'
    },
    ZK_BULK_ACCESS_UPLOAD_AD: {
        NAME: 'CARGA MASIVA ACCESO ARCOS DORADOS',
        MODULE: 'GESTIÓN ZK',
        FULL_PATH: BASE_PATH + 'zk/carga-masiva-acceso-ad'
    },
    CONFIG_USERS: {
        NAME: 'USUARIOS',
        MODULE: 'CONFIGURACIÓN',
        FULL_PATH: BASE_PATH + 'configuracion/usuarios'
    },
    CONFIG_PROFILES: {
        NAME: 'PERFILES',
        MODULE: 'CONFIGURACIÓN',
        FULL_PATH: BASE_PATH + 'configuracion/perfiles'
    },
    CONFIGS_LOGS: {
        NAME: 'AUDITORIA',
        MODULE: 'CONFIGURACIÓN',
        FULL_PATH: BASE_PATH + 'configuracion/registros'
    },
    DEVICE_CONFIG: {
        NAME: 'EMPRESAS',
        MODULE: 'EMPRESAS',
        FULL_PATH: BASE_PATH + 'empresas'
    },
    CLIENT_DATA: {
        NAME: 'CLIENTES',
        MODULE: 'EMPRESAS',
        FULL_PATH: BASE_PATH + 'clientes'
    },
    CLIENT_CONFIG: {
        NAME: 'MANTENEDOR CLIENTES',
        MODULE: 'CLIENTES',
        FULL_PATH: BASE_PATH + 'mantenedor-clientes'
    },
}