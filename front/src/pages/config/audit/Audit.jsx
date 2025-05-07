import { useState } from 'react';
import { fetchLogs } from '../../../api/usersApiRequest';
import { toast } from 'react-toastify';
import { useNavigate } from 'react-router-dom';
import { PUBLIC_ROUTES } from '../../../routes';
import './audit.css';

const PROCESS_OPTIONS = [
    'Iniciar Sesión',
    'Cerrar Sesión',
    'Consultar Clientes',
    'Consultar Licencia Cliente',
    'Actualizar Licencia Cliente',
    'Consultar Equipos',
    'Consultar Clientes Zk',
    'Enviar Usuario Zk',
    'Consultar Equipos Zk',
    'Carga Masiva Perfiles Acceso',
    'Consultar Perfiles Acceso',
    'Consultar Usuarios',
    'Crear Usuario',
    'Actualizar Usuario',
    'Consultar Perfiles',
    'Crear Perfil',
    'Actualizar Perfil',
    'Eliminar Perfil',
    'Consultar Logs',
];

const Audit = () => {
    const navigate = useNavigate();

    const formatToYyyyMmDd = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    };

    const [initDateFilter, setInitDateFilter] = useState(formatToYyyyMmDd(new Date()));
    const [endDateFilter, setEndDateFilter] = useState(formatToYyyyMmDd(new Date()));

    const [emailFilter, setEmailFilter] = useState('');
    const [processFilter, setProcessFilter] = useState('Todos');
    const [logs, setLogs] = useState([]);
    const [loading, setLoading] = useState(false);
    const [showModal, setShowModal] = useState(false);
    const [selectedLog, setSelectedLog] = useState(null);

    const formatDate = (dateString) => dateString ? new Date(dateString).toLocaleString() : 'N/A';

    

    const handleSearch = (e) => {
        e.preventDefault();
        if (loading) return;

        setLoading(true);

        fetchLogs(initDateFilter, endDateFilter, emailFilter, processFilter)
            .then((response) => {
                if (response) {
                    setLogs(response.data);
                    toast.success(response.message);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con la API de logs.");
                    setLogs([]);
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 400:
                        case 403:
                            setLogs([]);
                            toast.warning(error.response.data.message);
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 500:
                            setLogs([]);
                            toast.error(error.response.data.message);
                            break;
                        default:
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

    const handleResetFilters = () => {
        const defaultInit = formatToYyyyMmDd(new Date());
        const defaultEnd = formatToYyyyMmDd(new Date());

        setInitDateFilter(defaultInit);
        setEndDateFilter(defaultEnd);
        setEmailFilter('');
        setProcessFilter('Todos');
        setLogs([]);
    };

    return (
        <div className='audit-container'>
            <div className='audit-filter-section'>
                <h2 className='audit-filter-title'>Filtros de búsqueda:</h2>
                <form onSubmit={handleSearch}>
                    <div className='audit-filter-row'>
                        <div className='audit-filter-group'>
                            <label>Fecha Inicio:</label>
                            <input
                                type='date'
                                onFocus={(e) => e.target.showPicker()}
                                value={initDateFilter}
                                onChange={(e) => setInitDateFilter(e.target.value)}
                                disabled={loading}
                            />
                        </div>
                        <div className='audit-filter-group'>
                            <label>Fecha Fin:</label>
                            <input
                                type='date'
                                onFocus={(e) => e.target.showPicker()}
                                value={endDateFilter}
                                onChange={(e) => setEndDateFilter(e.target.value)}
                                disabled={loading}
                            />
                        </div>
                        <div className='audit-filter-group'>
                            <label>Email:</label>
                            <input
                                type='text'
                                value={emailFilter}
                                onChange={(e) => setEmailFilter(e.target.value)}
                                placeholder='Filtrar por email'
                                disabled={loading}
                            />
                        </div>
                        <div className='audit-filter-group'>
                            <label>Proceso:</label>
                            <select
                                value={processFilter}
                                onChange={(e) => setProcessFilter(e.target.value)}
                                disabled={loading}
                            >
                                <option value=''>Todos</option>
                                {PROCESS_OPTIONS.map((proc, index) => (
                                    <option key={index} value={proc}>{proc}</option>
                                ))}
                            </select>
                        </div>
                    </div>
                    <div className='audit-filter-actions'>
                        <button type='submit' className='audit-btn-primary' disabled={loading}>
                            {loading ? 'Buscando...' : 'Buscar'}
                        </button>
                        <button
                            type='button'
                            className='audit-btn-secondary'
                            onClick={handleResetFilters}
                            disabled={loading}>
                            Limpiar
                        </button>
                    </div>
                </form>
            </div>

            <div className='audit-results-section'>
                {loading ? (
                    <div className='audit-loading-indicator'>Cargando registros...</div>
                ) : (
                    <div className='audit-table-container'>
                        <table>
                            <thead className='audit-table-header'>
                                <tr>
                                    <th>Email</th>
                                    <th>Proceso</th>
                                    <th>Fecha</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody className='audit-table-body'>
                                {logs.length > 0 ? logs.map((log) => (
                                    <tr key={`${log.email}-${log.startDate}`}>
                                        <td>{log.email?.trim() ? log.email : 'Desconocido'}</td>
                                        <td>{log.processName}</td>
                                        <td>{formatDate(log.startDate)}</td>
                                        <td className='audit-actions-cell'>
                                            <button
                                                className='audit-btn-secondary'
                                                onClick={() => {
                                                    setSelectedLog(log);
                                                    setShowModal(true);
                                                }}>
                                                Detalle
                                            </button>
                                        </td>
                                    </tr>
                                )) : (
                                    <tr>
                                        <td colSpan="4" className='audit-no-results'>
                                            No se encontraron registros
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            {showModal && selectedLog && (
                <div className='audit-modal-overlay'>
                    <div className='audit-modal-content'>
                        <h2>Detalle del Registro</h2>
                        <div className='audit-log-details'>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Email:</span>
                                <span>{selectedLog.email}</span>
                            </div>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Proceso:</span>
                                <span>{selectedLog.processName}</span>
                            </div>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Fecha Inicio:</span>
                                <span>{formatDate(selectedLog.startDate)}</span>
                            </div>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Fecha Fin:</span>
                                <span>{formatDate(selectedLog.endDate)}</span>
                            </div>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Duración:</span>
                                <span>{new Date(selectedLog.endDate) - new Date(selectedLog.startDate)} ms</span>
                            </div>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Parámetros:</span>
                                <pre>{selectedLog.parameters}</pre>
                            </div>
                            <div className='audit-detail-row'>
                                <span className='audit-detail-label'>Respuesta:</span>
                                <pre>
                                    {typeof selectedLog.responseData === 'string'
                                        ? JSON.stringify(JSON.parse(selectedLog.responseData), null, 2)
                                        : JSON.stringify(selectedLog.responseData, null, 2)}
                                </pre>
                            </div>
                        </div>
                        <div className='audit-modal-actions'>
                            <button
                                className='audit-btn-primary'
                                onClick={() => setShowModal(false)}>
                                Cerrar
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Audit;