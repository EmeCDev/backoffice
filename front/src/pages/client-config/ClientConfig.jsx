import { useEffect, useState } from "react";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import { fetchCompaniesInfo, fetchDevices, updateCompanyVisibility } from "../../api/zkManagementApiRequests";
import { fetchLicenseData, fetchUpdateLicenseData } from "../../api/licenseRequests";
import { PUBLIC_ROUTES } from "../../routes";
import urlIcon from '../../assets/icons/url.png';
import refreshIcon from '../../assets/icons/refresh.png';
import './client-config.css';
import { Table } from "../../components";

const ClientConfig = () => {
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

    const [visibleGeneral, setVisibleGeneral] = useState(false);
    const [visibleZK, setVisibleZK] = useState(false);
    const [visibleDT, setVisibleDT] = useState(false);

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

        fetchCompaniesInfo(companyRut, companyName, true)
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

    const handleUpdateVisibility = () => {
        updateCompanyVisibility(selectedClient.id, visibleGeneral, visibleZK, visibleDT)
            .then((response) => {
                toast.success(response.message)
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
            });
    };


    const handleViewClient = (client) => {
        setLoading(true);

        if (userGrants.includes(900)) {
            setActiveTab('visible');
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

    const handleBackToList = () => {
        setSelectedClient(null);
    };

    if (selectedClient) {
        const tabs = []

        if (userGrants.includes(900)) {
            tabs.push({
                key: 'visible',
                label: 'Visible',
                content: (
                    <div className="visibility-updater">
                        <h3>Actualizar Visibilidad Cliente</h3>
                        <div className="visibility-status">

                            <div className="switch-container">
                                <label htmlFor="visibleGeneral">General:</label>
                                <div>
                                    <input
                                        type="checkbox"
                                        id="visibleGeneral"
                                        className="switch"
                                        checked={visibleGeneral}
                                        onChange={(e) => setVisibleGeneral(e.target.checked)}
                                    />
                                    <label className="slider" htmlFor="visibleGeneral"></label>
                                </div>
                            </div>

                            <div className="switch-container">
                                <label htmlFor="visibleZK">ZK:</label>
                                <div>
                                    <input
                                        type="checkbox"
                                        id="visibleZK"
                                        className="switch"
                                        checked={visibleZK}
                                        onChange={(e) => setVisibleZK(e.target.checked)}
                                    />
                                    <label className="slider" htmlFor="visibleZK"></label>
                                </div>
                            </div>

                            <div className="switch-container">
                                <label htmlFor="visibleDT">DT:</label>
                                <div>
                                    <input
                                        type="checkbox"
                                        id="visibleDT"
                                        className="switch"
                                        checked={visibleDT}
                                        onChange={(e) => setVisibleDT(e.target.checked)}
                                    />
                                    <label className="slider" htmlFor="visibleDT"></label>
                                </div>
                            </div>

                        </div>
                        <button className="button-active" onClick={handleUpdateVisibility}>Actualizar</button>
                    </div>
                )


            });
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

export default ClientConfig;