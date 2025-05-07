import { useEffect, useState } from "react";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import { fetchCompaniesInfo, fetchDevices } from "../../api/zkManagementApiRequests";
import { fetchLicenseData, fetchUpdateLicenseData } from "../../api/licenseRequests";
import { PUBLIC_ROUTES } from "../../routes";
import urlIcon from '../../assets/icons/url.png';
import refreshIcon from '../../assets/icons/refresh.png';
import './client-data.css';
import { Table } from "../../components";

const ClientData = () => {
    const [loading, setLoading] = useState(false);
    const [userGrants, setUserGrants] = useState(false);
    const [workersCount, setWorkersCount] = useState(0);
    const [workersCountInput, setWorkersCountInput] = useState(0);
    const [showModal, setShowModal] = useState(false);
    const [pendingUpdate, setPendingUpdate] = useState(null);
    const [expirationDate, setExpirationDate] = useState('');
    const [expirationDateInput, setExpirationDateInput] = useState('');
    const [companyName, setCompanyName] = useState("");
    const [companyRut, setCompanyRut] = useState("");
    const [results, setResults] = useState([]);
    const [selectedClient, setSelectedClient] = useState(null);
    const [activeTab, setActiveTab] = useState('equipos');
    const [clientDevices, setClientDevices] = useState([]);
    const navigate = useNavigate();


    useEffect(() => {
        let parsedData = {};

        try {
            parsedData = JSON.parse(sessionStorage.getItem("userData")) || {};
        } catch (error) {
            console.error("Error parsing userData:", error);
        }

        setUserGrants(parsedData?.grants ?? []);
    }, [])

    const handleSearch = async (e) => {
        e.preventDefault();
        setLoading(true);

        const role = userGrants.includes(900);

        fetchCompaniesInfo(companyRut, companyName, role)
            .then((response) => {
                if (response) {
                    toast.success(response.message);
                    setResults(response.data || []);
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
                            setResults([]);
                            break;
                        case 500:
                            toast.error(error.response.data.message);
                            setResults([]);
                            break;
                        default:
                            toast.error("Error inesperado.");
                            break;
                    }
                } else {
                    toast.error("Error desconocido.");
                }
            })
            .finally(() => {
                setLoading(false);
            });
    };

    const handleReset = () => {
        setCompanyName("");
        setCompanyRut("");
        setResults([]);
    };


    const parseDate = (dateStr) => {
        const [day, month, year, hours, minutes, seconds] = dateStr.split(/[-\s:]+/);
        return new Date(`${year}-${month}-${day}T${hours}:${minutes}:${seconds}`);
    };

    const renderConnectionStatusBadge = (lastConnectionDateStr) => {
        if (!lastConnectionDateStr) {
            return (
                <span className="badge-grey">
                    Desconocido
                </span>
            );
        }

        const lastConnection = parseDate(lastConnectionDateStr);

        if (isNaN(lastConnection.getTime())) {
            return (
                <span className="badge-grey">
                    Fecha inválida
                </span>
            );
        }

        const now = new Date();
        const diffMs = now - lastConnection;
        const diffMins = diffMs / 1000 / 60;

        let badgeClass = 'badge-green';

        if (diffMins >= 180) {
            badgeClass = 'badge-red';
        } else if (diffMins >= 30) {
            badgeClass = 'badge-orange';
        } else if (diffMins >= 5) {
            badgeClass = 'badge-yellow';
        }

        return (
            <span className={`badge ${badgeClass}`}>
                {lastConnectionDateStr}
            </span>
        );
    };


    const handleViewClient = (client) => {
        setLoading(true);

        if (userGrants.includes(300)) {
            setActiveTab('equipos');
        }
        else if (userGrants.includes(400)) {
            setActiveTab('licencias');
        }

        if (userGrants.includes(300)) {
            fetchDevices(client.servidor, client.bdGenhoras)
                .then((response) => {
                    if (response) {

                        const devices = response.data;

                        setClientDevices(devices);

                        const clientWithDetails = {
                            ...client,
                            equipos: devices.map(device => ({
                                id: device.SerialNumber,
                                nombre: device.Description,
                                tipo: device.Model,
                                activo: device.Active === "true",
                                ubicacion: device.Location,
                                funcion: device.Function,
                                ultimaConexion: device.LastConnectionDate,
                                tiempoDesconexion: device.disconnectionTimeHrs
                            }))
                        };

                        setSelectedClient(clientWithDetails);
                    }
                })
                .catch((error) => {

                    setClientDevices([])

                    const clientWithDetails = {
                        ...client,
                        equipos: []
                    };

                    setSelectedClient(clientWithDetails);

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
                                setResults([]);
                                break;
                            case 500:
                                toast.error(error.response.data.message);
                                setResults([]);
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
        }

        if (userGrants.includes(400)) {
            fetchLicenseData(client.servidor, client.bdGenhoras)
                .then((response) => {
                    if (response) {

                        const licenseData = response.data;

                        const clientWithDetails = {
                            ...client,
                            licencias: {
                                fechaExpiracion: licenseData.expirationDate ?? 'No se encontraron datos.',
                                cantidadTrabajadores: licenseData.workersCount ?? 'No se encontraron datos.'
                            }
                        };

                        const dateParts = licenseData.expirationDate.split('-');
                        const day = dateParts[0];
                        const month = dateParts[1];
                        const year = dateParts[2];

                        const newExpirationDate = `${day}-${month}-${year}`
                        const expExpirationDateInput = `${year}-${month}-${day}`

                        setExpirationDate(newExpirationDate)

                        setExpirationDateInput(expExpirationDateInput)

                        setWorkersCountInput(licenseData.workersCount)

                        setWorkersCount(licenseData.workersCount)

                        setSelectedClient(clientWithDetails);
                    }
                })
                .catch((error) => {

                    const clientWithDetails = {
                        ...client,
                        licencias: {
                            fechaExpiracion: 'No se encontraron datos.',
                            cantidadTrabajadores: 'No se encontraron datos.'
                        }
                    };

                    setSelectedClient(clientWithDetails);

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
                                setResults([]);
                                break;
                            case 500:
                                toast.error(error.response.data.message);
                                setResults([]);
                                break;
                            default:
                                toast.error("Error inesperado.");
                                break;
                        }
                    } else {
                        toast.error("Error desconocido.");
                    }
                })
                .finally(() => {
                    setLoading(false);
                });
        }

    };

    const handleRefreshDevices = () => {
        if (!selectedClient) return;


        setClientDevices([]);
        const resetedClient = {
            ...selectedClient,
            equipos: []
        };

        setLoading(true);

        setSelectedClient(resetedClient);

        fetchDevices(selectedClient.servidor, selectedClient.bdGenhoras)
            .then((response) => {
                const devices = response.data;

                const updatedClient = {
                    ...selectedClient,
                    equipos: devices.map(device => ({
                        id: device.SerialNumber,
                        nombre: device.Description,
                        tipo: device.Model,
                        activo: device.Active === "true",
                        ubicacion: device.Location,
                        funcion: device.Function,
                        ultimaConexion: device.LastConnectionDate,
                        tiempoDesconexion: device.disconnectionTimeHrs
                    }))
                };

                setSelectedClient(updatedClient);

                setClientDevices(devices);

                toast.success("Equipos actualizados correctamente");
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
                            setResults([]);
                            break;
                        case 500:
                            toast.error(error.response.data.message);
                            setResults([]);
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

    const handleBackToList = () => {
        setSelectedClient(null);
        setClientDevices([]);
        setExpirationDate('');
        setWorkersCount(0);
    };

    if (selectedClient) {
        const tabs = []

        if (userGrants.includes(300)) {
            tabs.push({
                key: 'equipos',
                label: 'Equipos',
                content: (
                    <div className="equipos-section">
                        <div className="ficha-equipos-acciones">
                            <h3>Equipos:</h3>
                            <button
                                className="admin-icon-btn"
                                title="Actualizar lista de equipos"
                                onClick={handleRefreshDevices}
                                disabled={loading}
                            >
                                <img src={refreshIcon} alt="Actualizar" className="refresh-icon" />
                            </button>
                        </div>

                        <div className="equipos-leyenda">
                            <span>Tiempo de desconexión de equipos: </span>
                            <span className="leyenda-item"><span className="badge badge-verde" /> &lt; 5 min</span>
                            <span className="leyenda-item"><span className="badge badge-amarillo" /> 5 - 30 min</span>
                            <span className="leyenda-item"><span className="badge badge-naranjo" /> 30 min - 3 hrs</span>
                            <span className="leyenda-item"><span className="badge badge-rojo" /> &gt; 3 hrs</span>
                        </div>

                        <Table
                            headers={['Serie', 'Modelo', 'Nombre Equipo', 'Locación', 'Funcion', 'Ultima Conexión', 'Tiempo de desconexión']}
                            columns={clientDevices.map(device => {
                                return [
                                    device.serialNumber,
                                    device.model,
                                    device.description,
                                    device.location,
                                    device.function,
                                    renderConnectionStatusBadge(device.lastConnectionDate),
                                    device.disconnectionTime ? device.disconnectionTime + ' hrs' : '0 hrs'
                                ];
                            })}
                            objectName='equipos'
                        />
                    </div>

                )

            });
        }

        if (userGrants.includes(301)) {
            tabs.push({
                key: 'equipos-cofig',
                label: 'Configuración Equipos',
                content: (
                    <div className="equipos-section">

                        {selectedClient.servidor == 1 && (
                            <>
                                <h3>Configuraciones servidor 1:</h3>

                                {/* IP del servidor */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title"><strong>IP SERVIDOR: </strong><span style={{ fontWeight: 'normal' }}>020.065.046.237</span></h4>
                                </div>

                                {/* Modelo: LINEA H */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: LINEA H</h4>
                                    <p><strong>Puerto:</strong> <span>8085</span></p>

                                    <div className="config-injes-section">
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Asistencia:</span>
                                            <span>WS_TEMPOH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Acceso:</span>
                                            <span>WS_ACCESOH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Casino:</span>
                                            <span>WS_SNACKH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Presencia:</span>
                                            <span>WS_PRESENCIAH_SUFIJO</span>
                                        </div>
                                    </div>
                                </div>

                                {/* Modelo: INJES A8 */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: A8</h4>
                                    <p><strong>Puerto:</strong> <span>8086</span></p>
                                </div>

                                {/* Modelo: INJES A9 - A35 - A36 - DT20 */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: A9 - A35 - A36 - DT20</h4>
                                    <p><strong>Puerto:</strong> <span>8088</span></p>
                                </div>


                                {/* ZK */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos ZK</h4>
                                    <p><strong>HTTPS:</strong> <span>Activo</span></p>
                                    <p><strong>DNS:</strong> <span>clghz0xp1sl02.genera.cl</span></p>
                                </div>
                            </>
                        )}

                        {selectedClient.servidor == 2 && (
                            <>
                                <h3>Configuraciones servidor 2:</h3>

                                {/* IP del servidor */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title"><strong>IP SERVIDOR: </strong><span style={{ fontWeight: 'normal' }}>20.65.46.237</span></h4>
                                </div>

                                {/* Modelo: LINEA H */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: LINEA H</h4>
                                    <p><strong>Puerto:</strong> <span>8085</span></p>

                                    <div className="config-injes-section">
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Asistencia:</span>
                                            <span>WS_TEMPOH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Acceso:</span>
                                            <span>WS_ACCESOH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Casino:</span>
                                            <span>WS_SNACKH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Presencia:</span>
                                            <span>WS_PRESENCIAH_SUFIJO</span>
                                        </div>
                                    </div>
                                </div>

                                {/* Modelo: INJES A8 */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: A8</h4>
                                    <p><strong>Puerto:</strong> <span>8087</span></p>
                                </div>

                                {/* Modelo: INJES A9 - A35 - A36 - DT20 */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: A9 - A35 - A36 - DT20</h4>
                                    <p><strong>Puerto:</strong> <span>8089</span></p>
                                </div>


                                {/* ZK */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos ZK</h4>
                                    <p><strong>HTTPS:</strong> <span>Activo</span></p>
                                    <p><strong>DNS:</strong> <span>clghz0xp2sl02.genera.cl</span></p>
                                </div>
                            </>
                        )}

                        {selectedClient.servidor == 3 && (
                            <>
                                <h3>Configuraciones servidor 3:</h3>

                                {/* IP del servidor */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title"><strong>IP SERVIDOR: </strong><span style={{ fontWeight: 'normal' }}>20.65.46.237</span></h4>
                                </div>

                                {/* Modelo: LINEA H */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: LINEA H</h4>
                                    <p><strong>Puerto:</strong> <span>8085</span></p>

                                    <div className="config-injes-section">
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Asistencia:</span>
                                            <span>WS_TEMPOH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Acceso:</span>
                                            <span>WS_ACCESOH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Casino:</span>
                                            <span>WS_SNACKH_SUFIJO</span>
                                        </div>
                                        <div className="config-inje-item">
                                            <span className="config-inje-title">Presencia:</span>
                                            <span>WS_PRESENCIAH_SUFIJO</span>
                                        </div>
                                    </div>
                                </div>

                                {/* Modelo: INJES A8 */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: A8</h4>
                                    <p><strong>Puerto:</strong> <span>8087</span></p>
                                </div>

                                {/* Modelo: INJES A9 - A35 - A36 - DT20 */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos: A9 - A35 - A36 - DT20</h4>
                                    <p><strong>Puerto:</strong> <span>8089</span></p>
                                </div>


                                {/* ZK */}
                                <div className="config-linea-section">
                                    <h4 className="config-linea-title">Equipos ZK</h4>
                                    <p><strong>HTTPS:</strong> <span>Activo</span></p>
                                    <p><strong>DNS:</strong> <span>clghz0xp3sl02.genera.cl</span></p>
                                </div>
                            </>
                        )}

                    </div>
                )

            });
        }

        const formatDateForDisplay = (dateStr) => {
            const [year, month, day] = dateStr.split('-');
            return `${day}-${month}-${year}`;
        };


        if (userGrants.includes(400)) {
            tabs.push(
                {
                    key: 'licencias',
                    label: 'Licencia',
                    content: (
                        <div className="licencias-section">
                            <h3>Licencia actual del cliente</h3>

                            <div className="licencia-info">
                                <ul className="client-card-info-list">
                                    <li>
                                        <strong className="label-spacing">Expiración: </strong> {expirationDate || 'No se encontraron datos.'}
                                    </li>
                                    <li>
                                        <strong className="label-spacing">Trabajadores: </strong> {workersCount || 'No se encontraron datos.'}
                                    </li>
                                </ul>
                            </div>

                            <hr className="divider" />

                            <h3>Actualizar Licencia</h3>
                            <form className="licencia-update-form" onSubmit={(e) => {
                                e.preventDefault();
                                if (!expirationDate || !workersCount || workersCount <= 0) {
                                    toast.error("Por favor, complete todos los campos correctamente.");
                                    return;
                                }

                                // Guarda la nueva licencia en el estado y muestra el modal
                                setPendingUpdate({
                                    newExpirationDate: expirationDateInput,
                                    newWorkersCount: workersCountInput
                                });
                                setShowModal(true);
                            }}>
                                <div className="form-group">
                                    <label htmlFor="expirationDate">Nueva Fecha de Expiración:</label>
                                    <input
                                        type="date"
                                        id="expirationDate"
                                        name="expirationDate"
                                        value={expirationDateInput}
                                        onMouseDown={(e) => e.target.showPicker()}
                                        onChange={(e) => setExpirationDateInput(e.target.value)}
                                        required
                                    />
                                </div>

                                <div className="form-group">
                                    <label htmlFor="workersCount">Cantidad de Trabajadores:</label>
                                    <input
                                        type="number"
                                        id="workersCount"
                                        name="workersCount"
                                        value={workersCountInput}
                                        onChange={(e) => setWorkersCountInput(e.target.value)}
                                        required
                                    />
                                </div>

                                <button
                                    type="submit"
                                    className="admin-btn admin-btn-primary"
                                    disabled={loading}
                                >
                                    {loading ? "Actualizando..." : "Actualizar"}
                                </button>
                            </form>

                            {showModal && (
                                <div className="modal-overlay">
                                    <div className="modal">
                                        <h2>¿Está seguro que desea actualizar la licencia?</h2>
                                        <p>
                                            <strong>Licencia anterior:</strong> {expirationDate} ({workersCount} trabajadores) <br />
                                            <strong>Nueva licencia:</strong> {formatDateForDisplay(pendingUpdate.newExpirationDate)} ({pendingUpdate.newWorkersCount} trabajadores)
                                        </p>

                                        <div className="modal-actions">
                                            <button
                                                className="admin-btn admin-btn-primary"
                                                onClick={() => {
                                                    setShowModal(false);
                                                    setLoading(true);

                                                    fetchUpdateLicenseData(
                                                        selectedClient.servidor,
                                                        selectedClient.bdGenhoras,
                                                        pendingUpdate.newExpirationDate,
                                                        pendingUpdate.newWorkersCount,
                                                        expirationDate,
                                                        workersCount
                                                    )
                                                        .then((response) => {
                                                            if (response) {
                                                                toast.success(response.message);

                                                                const updatedClient = {
                                                                    ...selectedClient,
                                                                    licencias: {
                                                                        fechaExpiracion: response.data.expirationDate,
                                                                        cantidadTrabajadores: response.data.workersCount
                                                                    }
                                                                };

                                                                const dateParts = response.data.expirationDate.split('-');
                                                                const [day, month, year] = dateParts;
                                                                const newExpirationDate = `${day}-${month}-${year}`;
                                                                const expExpirationDateInput = `${year}-${month}-${day}`;

                                                                setExpirationDate(newExpirationDate);
                                                                setExpirationDateInput(expExpirationDateInput);
                                                                setSelectedClient(updatedClient);
                                                                setWorkersCount(response.data.workersCount);
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
                                                                        setResults([]);
                                                                        break;
                                                                    case 500:
                                                                        toast.error(error.response.data.message);
                                                                        setResults([]);
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
                                                }}
                                            >
                                                Actualizar
                                            </button>
                                            <button
                                                className="admin-btn admin-btn-secondary"
                                                onClick={() => {
                                                    setShowModal(false);
                                                    setPendingUpdate(null);
                                                }}
                                            >
                                                Cancelar
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>
                    )

                }
            );
        }

        return (
            <div className="client-section-ficha">
                <div className="client-card-container">
                    <div className="client-card-header">
                        <h1>{selectedClient.nombreEmpresa}</h1>
                    </div>
                    <div className="client-card-section">
                        <h3>Datos:</h3>
                        <ul className="client-card-info-list">
                            <li><strong className="label-spacing">RUT:</strong> {selectedClient.rutEmpresa}-{selectedClient.dv}</li>
                            <li><strong className="label-spacing">Plataforma:</strong> {selectedClient.tipoCliente === 'PO' ? 'Portal' : '3.0 DT'}</li>
                            <li><strong className="label-spacing">Servidor:</strong> {selectedClient.servidor}</li>
                            <li><strong className="label-spacing">Base de Datos:</strong> {selectedClient.bdGenhoras}</li>
                        </ul>
                    </div>
                    <div className="client-card-section">
                        <h3>URL:</h3>
                        <a href={selectedClient.urlCliente} target="_blank" rel="noopener noreferrer" className="client-card-url">
                            {selectedClient.urlCliente}
                        </a>
                    </div>

                    <button onClick={handleBackToList} className="client-card-back-btn">← Volver a resultados</button>
                </div>

                <div className="client-data-ficha">
                    <div className="ficha-tabs">
                        {tabs.map(tab => (
                            <button
                                key={tab.key}
                                className={`ficha-tab ${activeTab === tab.key ? 'active' : ''}`}
                                onClick={() => setActiveTab(tab.key)}
                            >
                                {tab.label}
                            </button>
                        ))}
                    </div>
                    {tabs.find(tab => tab.key === activeTab)?.content}
                </div>
            </div>
        );
    }

    return (
        <div className="admin-container">
            <form className="admin-filter-section" onSubmit={handleSearch}>
                <h3 className="zk-section-subtitle">Filtros de búsqueda:</h3>
                <div className="admin-filter-row">
                    <div className="admin-filter-group">
                        <label>Nombre:</label>
                        <input type="text" value={companyName} onChange={(e) => setCompanyName(e.target.value)} />
                    </div>
                    <div className="admin-filter-group">
                        <label>RUT:</label>
                        <input type="text" value={companyRut} onChange={(e) => setCompanyRut(e.target.value)} />
                    </div>
                </div>
                <div className="admin-actions">
                    <button type="submit" className="admin-btn admin-btn-primary" disabled={loading}>
                        {loading ? "Buscando..." : "Buscar"}
                    </button>
                    <button type="button" className="admin-btn admin-btn-secondary" onClick={handleReset}>
                        Borrar Filtros
                    </button>
                </div>
            </form>

            <Table
                headers={['Rut', 'Nombre Empresa', 'Servidor', 'Acciones']}
                columns={results.map(item => ([
                    item.rutEmpresa + '-' + item.dv,
                    item.nombreEmpresa,
                    item.servidor,
                    (<img key={item.rutEmpresa} src={urlIcon} alt="Ver Ficha" className="button-ver-ficha" onClick={() => handleViewClient(item)} />)
                ]))}
                objectName='empresas'
            />
        </div >
    );
};

export default ClientData;