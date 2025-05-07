import { useState, useEffect } from 'react';
import './zksenduser.css';
import { toast } from 'react-toastify';
import { fetchZkCompanies, fetchZkDevices, sendUserToDevices } from '../../../api/zkManagementApiRequests';
import { PUBLIC_ROUTES } from '../../../routes';
import { useNavigate } from 'react-router-dom';

const ZkSendUser = () => {

    const navigate = useNavigate();

    // ==================== ESTADOS ====================
    // Configuración del sistema
    const [serverId, setServerId] = useState(0);
    const [companyId, setCompanyId] = useState(0);
    const [companyDb, setCompanyDb] = useState('');
    const [companies, setCompanies] = useState([{ companyId: 0, client: '[Seleccione]' }]);

    // Dispositivos
    const [availableDevices, setAvailableDevices] = useState([]);
    const [selectedDevices, setSelectedDevices] = useState([]);

    // Datos del usuario
    const [userData, setUserData] = useState({
        pin: '',
        name: '',
        privilege: -1,
        password: '',
        card: ''
    });

    useEffect(() => {
        if (serverId !== 0) {
            setCompanies([{ companyId: 0, client: '[Seleccione]' }]);
            setCompanyId(0);
            setCompanyDb('');
        }
    }, [serverId])

    const [sendAdminUser, setSendAdminUser] = useState(false);
    const [loading, setLoading] = useState(false);

    // ==================== OPCIONES ====================
    const serverOptions = [
        { value: 0, label: '[ Seleccione ]' },
        { value: 1, label: 'Servidor 1' },
        { value: 2, label: 'Servidor 2' },
        { value: 3, label: 'Servidor 3' }
    ];

    const privilegeOptions = [
        { value: null, label: 'Seleccione' },
        { value: 0, label: 'Usuario' },
        { value: 14, label: 'Administrador' }
    ];

    // ==================== EFECTOS ====================
    // Cargar empresas cuando cambia el servidor
    useEffect(() => {
        if (serverId === 0) {
            setCompanies([{ companyId: 0, client: '[Seleccione]' }]);
            setCompanyId(0);
            setCompanyDb('');
            return;
        }

        setLoading(true);
        fetchZkCompanies(serverId, '')
            .then((response) => {
                if (response) {
                    setCompanies([{ companyId: 0, client: '[Seleccione]' }, ...response.data]);
                }
            })
            .catch((error) => {
                setCompanies([{ companyId: 0, client: '[Seleccione]' }]);
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con la API.");
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning("Su sesión ha expirado.");
                            break;
                        case 400:
                        case 403:
                            toast.warning(error.response.data.message);
                            break;
                        case 500:
                            toast.error(error.response.data.message);
                            break;
                        default:
                            toast.error("Error inesperado.");
                            break;
                    }
                } else {
                    toast.error("Error desconocido al intentar obtener datos de la api Equipos.");
                }
            })
            .finally(() => {
                setLoading(false);
            });
    }, [serverId]);

    useEffect(() => {

        if (companyId == 0 || !companyDb) {
            setAvailableDevices([]);
            setSelectedDevices([]);
            setCompanyId();
            setCompanyDb('');
            return;
        }

        setLoading(true);
        fetchZkDevices(serverId, companyDb, null)
            .then(response => {
                if (response) {
                    setAvailableDevices(response.data);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con la API.");
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning("Su sesión ha expirado.");
                            break;
                        case 400:
                        case 403:
                            toast.warning(error.response.data.message);
                            break;
                        case 500:
                            toast.error(error.response.data.message);
                            break;
                        default:
                            toast.error("Error inesperado.");
                            break;
                    }
                } else {
                    toast.error("Error desconocido al intentar obtener datos de la api Equipos.");
                }
                setAvailableDevices([]);
            })
            .finally(() => {
                setLoading(false);
            });
    }, [companyDb]);

    // Autocompletar datos de admin
    useEffect(() => {
        if (sendAdminUser) {
            setUserData({
                pin: '9999',
                name: 'Admin',
                privilege: 14,
                password: '9999',
                card: '9999'
            });
        } else {
            setUserData({
                pin: '',
                name: '',
                privilege: -1,
                password: '',
                card: ''
            });
        }
    }, [sendAdminUser]);

    // ==================== MANEJADORES ====================
    const handleSystemConfigChange = (e) => {
        const { name, value } = e.target;
        if (name === 'serverId') {
            setServerId(Number(value));
        } else if (name === 'companyId') {
            const selectedCompany = companies.find(c => c.companyId == value);
            setCompanyId(Number(value));
            setCompanyDb(selectedCompany?.databaseName || '');
        }
    };

    const handleUserDataChange = (e) => {
        const { name, value } = e.target;
        setUserData(prev => ({
            ...prev,
            [name]: name === 'privilege' ? Number(value) : value
        }));
    };

    const handleDeviceSelection = (serialNumber, isChecked) => {
        setSelectedDevices(prev =>
            isChecked
                ? [...prev, serialNumber]
                : prev.filter(sn => sn !== serialNumber)
        );
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        setLoading(true);

        // Validaciones del sistema
        if (serverId === 0 || companyId === 0 || !companyDb) {
            toast.warning('Seleccione servidor y empresa válidos');
            setLoading(false);
            return;
        }

        // Validaciones de dispositivos
        if (selectedDevices.length === 0) {
            toast.warning('Seleccione al menos un dispositivo');
            setLoading(false);
            return;
        }

        // Validaciones del usuario
        if (userData.privilege === -1 || !userData.pin || !userData.name || !userData.password) {
            toast.warning('Complete todos los campos del usuario');
            setLoading(false);
            return;
        }

        // Preparar datos para enviar
        const payload = {
            ServerId: serverId,
            DatabaseName: companyDb,  // Cambiado de CompanyId a DatabaseName
            Pin: userData.pin,
            Name: userData.name,
            Privilege: userData.privilege,
            Password: userData.password,
            Card: userData.card,
            DevicesSerialNumbers: selectedDevices
        };

        sendUserToDevices(payload)
            .then((response) => {
                if (response.statusCode && response.statusCode === 200) {
                    setServerId(0);
                    toast.success(response.message);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con la API.");
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning("Su sesión ha expirado.");
                            break;
                        case 400:
                        case 403:
                            toast.warning(error.response.data.message);
                            break;
                        case 500:
                            toast.error(error.response.data.message);
                            break;
                        default:
                            toast.error("Error inesperado.");
                            break;
                    }
                } else {
                    toast.error("Error desconocido al intentar obtener datos de la api Equipos.");
                }
            })
            .finally(() => {
                setLoading(false);
            });
    };

    const handleReset = () => {
        setServerId(0);
        setCompanyId(0);
        setCompanyDb('');
        setSelectedDevices([]);
        setUserData({
            pin: '',
            name: '',
            privilege: -1,
            password: '',
            card: ''
        });
        setSendAdminUser(false);
    };

    // ==================== RENDER ====================
    return (
        <div className='zk-devices-container'>
            <div className='filter-section'>
                <form onSubmit={handleSubmit}>
                    {/* SECCIÓN 1: CONFIGURACIÓN DEL SISTEMA */}
                    <div className='system-config-section'>
                        <h3>Selección de empresa</h3>

                        <div className='filter-row'>
                            <div className='filter-group'>
                                <label>Servidor:</label>
                                <select
                                    name="serverId"
                                    value={serverId}
                                    onChange={handleSystemConfigChange}
                                    className='form-select'
                                    required
                                    disabled={loading}
                                >
                                    {serverOptions.map(option => (
                                        <option key={option.value} value={option.value}>
                                            {option.label}
                                        </option>
                                    ))}
                                </select>
                            </div>

                            <div className='filter-group'>
                                <label>Empresa:</label>
                                <select
                                    name="companyId"
                                    value={companyId}
                                    onChange={handleSystemConfigChange}
                                    className='form-select'
                                    required
                                    disabled={loading || serverId === 0}
                                >
                                    {companies.map(company => (
                                        <option key={company.companyId} value={company.companyId}>
                                            {company.client}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* SECCIÓN 2: SELECCIÓN DE DISPOSITIVOS */}
                    <div className='devices-section'>
                        <h3>Selección de Equipos</h3>

                        <div className='filter-row'>
                            <div className='filter-group devices-group'>
                                <label>Equipos Disponibles:</label>
                                <div className='devices-selection-container'>
                                    {availableDevices.length > 0 ? (
                                        availableDevices.map(device => (
                                            <div key={device.serialNumber} className='device-checkbox'>
                                                <input
                                                    type="checkbox"
                                                    id={`dev-${device.serialNumber}`}
                                                    checked={selectedDevices.includes(device.serialNumber)}
                                                    onChange={(e) => handleDeviceSelection(device.serialNumber, e.target.checked)}
                                                    disabled={loading}
                                                />
                                                <label htmlFor={`dev-${device.serialNumber}`}>
                                                    <strong>{device.description}</strong><br />
                                                    {device.serialNumber} ({device.function})
                                                </label>
                                            </div>
                                        ))
                                    ) : (
                                        <p className='no-devices'>
                                            {companyId === 0
                                                ? 'Seleccione una empresa'
                                                : 'No hay equipos disponibles'}
                                        </p>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* SECCIÓN 3: DATOS DEL USUARIO */}
                    <div className='user-data-section'>
                        <h3>Datos del Usuario</h3>

                        <div className="admin-user-data">
                            <input
                                type="checkbox"
                                name="adminUser"
                                id="adminUser"
                                checked={sendAdminUser}
                                onChange={(e) => setSendAdminUser(e.target.checked)}
                            />
                            <label htmlFor="adminUser">Datos Administrador</label>
                        </div>

                        <div className='filter-row'>
                            <div className='filter-group'>
                                <label>PIN:</label>
                                <input
                                    type="number"
                                    name="pin"
                                    value={userData.pin}
                                    onChange={handleUserDataChange}
                                    placeholder="9999"
                                    required
                                    disabled={loading || sendAdminUser}
                                />
                            </div>

                            <div className='filter-group'>
                                <label>Nombre Completo:</label>
                                <input
                                    type="text"
                                    name="name"
                                    value={userData.name}
                                    onChange={handleUserDataChange}
                                    placeholder="Juan Pérez"
                                    required
                                    disabled={loading || sendAdminUser}
                                />
                            </div>
                        </div>

                        <div className='filter-row'>
                            <div className='filter-group'>
                                <label>Privilegio:</label>
                                <select
                                    name="privilege"
                                    value={userData.privilege}
                                    onChange={handleUserDataChange}
                                    className='form-select'
                                    required
                                    disabled={loading || sendAdminUser}
                                >
                                    {privilegeOptions.map(option => (
                                        <option key={option.value} value={option.value}>
                                            {option.label}
                                        </option>
                                    ))}
                                </select>
                            </div>

                            <div className='filter-group'>
                                <label>Contraseña:</label>
                                <input
                                    type="number"
                                    name="password"
                                    value={userData.password}
                                    onChange={handleUserDataChange}
                                    placeholder="9999"
                                    required
                                    disabled={loading || sendAdminUser}
                                />
                            </div>

                            <div className='filter-group'>
                                <label>Tarjeta: </label>
                                <input
                                    type="number"
                                    name="card"
                                    value={userData.card}
                                    onChange={handleUserDataChange}
                                    placeholder="9999"
                                    disabled={loading || sendAdminUser}
                                />
                            </div>
                        </div>
                    </div>

                    {/* SECCIÓN 4: ACCIONES */}
                    <div className='send-user-actions-section'>
                        <div className='filter-actions'>
                            <button
                                type='submit'
                                className={loading ? 'btn-loading' : 'btn-primary'}
                                disabled={loading}
                            >
                                {loading ? (
                                    <>
                                        <span className="button-spinner"></span>
                                        Enviando...
                                    </>
                                ) : 'Enviar Usuario'}
                            </button>
                            <button
                                type='button'
                                className='btn-secondary'
                                onClick={handleReset}
                                disabled={loading}
                            >
                                Limpiar
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default ZkSendUser;