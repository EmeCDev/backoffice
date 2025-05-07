import { useEffect, useState } from 'react';
import './zkdevices.css';
import { fetchZkCompanies, fetchZkDevices } from '../../../api/zkManagementApiRequests';
import { toast } from 'react-toastify';
import { PUBLIC_ROUTES } from '../../../routes';
import { useNavigate } from 'react-router-dom';

const ZKDevices = () => {
  const navigate = useNavigate();

  // Estados para los filtros
  const [serverId, setServerId] = useState(0);
  const [companyId, setCompanyId] = useState(0);
  const [companyDb, setCompanyDb] = useState('');
  const [serialNumber, setSerialNumber] = useState('');

  const [companies, setCompanies] = useState([{ companyId: 0, client: '[ Seleccione ]' }]);
  const [devices, setDevices] = useState([]);
  const [loading, setLoading] = useState(false);

  const serverOptions = [
    { value: 0, label: '[ Seleccione ]' },
    { value: 1, label: 'Servidor 1' },
    { value: 2, label: 'Servidor 2' },
    { value: 3, label: 'Servidor 3' }
  ];

  useEffect(() => {
    if (serverId === 0) {
      setCompanyId(0);
      setCompanyDb('');
      setSerialNumber('');
      setCompanies([{ companyId: 0, client: '[ Seleccione ]' }]);
    }
  }, [serverId]);

  const getConnectionStatus = (lastConnection) => {
    if (!lastConnection) return 'disconnected';

    const now = new Date();
    const lastConnDate = new Date(lastConnection);
    const diffInSeconds = (now - lastConnDate) / 1000;

    if (diffInSeconds <= 900) return 'connected';
    if (diffInSeconds <= 3600) return 'warning';
    return 'disconnected';
  };

  useEffect(() => {
    if (serverId == 0) return;

    fetchZkCompanies(serverId, '')
      .then((response) => {
        if (response) {
          setCompanies([{ companyId: 0, client: '[ Seleccione ]' }, ...response.data]);
        }
      })
      .catch(() => {
        setCompanies([{ companyId: 0, client: '[ Seleccione ]' }]);
      })
  }, [serverId]);

  const handleSubmit = (e) => {
    e.preventDefault();

    if (serverId === 0) {
      toast.warning('Por favor seleccione un servidor válido');
      return;
    }

    setLoading(true);
    fetchZkDevices(serverId, companyDb, serialNumber)
      .then((response) => {
        if (response) {
          toast.success(response.message);
          setDevices(response.data);
        }
      })
      .catch((error) => {
        if (error.code === "ERR_NETWORK") {
          toast.error("No se pudo establecer conexión con la API de gestión de equipos.");
        } else if (error.response?.data) {
          switch (error.response.data.statusCode) {
            case 401:
              navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
              toast.warning('Su sesión ha expirado.');
              break;
            case 400:
              toast.warning(error.response.data.message);
              setDevices([]);
              break;
            case 500:
              toast.error(error.response.data.message);
              setDevices([]);
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

  const handleReset = (e) => {
    e.preventDefault();
    setServerId(0);
    setCompanyId(0);
    setCompanyDb('');
    setSerialNumber('');
    setDevices([]);
  };

  const formatDateTime = (dateString) => {
    if (!dateString) return 'Nunca conectado';

    try {
      const date = new Date(dateString);
      const day = String(date.getDate()).padStart(2, '0');
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const year = date.getFullYear();
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');

      return `${day}-${month}-${year} ${hours}:${minutes}`;
    } catch {
      return 'Formato inválido';
    }
  };

  return (
    <div className='zk-devices-container'>
      <div className='devices-filter-section'>
        <h2 className='filter-subtittle'>Filtros de búsqueda:</h2>
        <form onSubmit={handleSubmit}>
          <div className='filter-row'>
            <div className='filter-group'>
              <label htmlFor='ServerId'>Servidor:</label>
              <select
                id='ServerId'
                name='ServerId'
                value={serverId}
                onChange={(e) => setServerId(Number(e.target.value))}
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
              <label htmlFor='CompanyId'>Empresa:</label>
              <select
                id='CompanyId'
                name='CompanyId'
                value={companyId}
                onChange={(e) => {
                  const selectedCompany = companies.find(c => c.companyId == e.target.value);
                  setCompanyId(e.target.value);
                  setCompanyDb(selectedCompany?.databaseName || '');
                }}
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

            <div className='filter-group'>
              <label htmlFor='SerialNumber'>Número de Serie:</label>
              <input
                type='text'
                id='SerialNumber'
                name='SerialNumber'
                value={serialNumber}
                onChange={(e) => setSerialNumber(e.target.value)}
                placeholder='CNSX214960005'
                disabled={loading}
              />
            </div>
          </div>

          <div className='filter-row'>
            <div className='filter-actions'>
              <button
                type='submit'
                className={loading ? 'devices-loading' : 'devices-btn-primary'}
                disabled={loading}
              >
                {loading ? ('Cargando . . .') : 'Buscar'}
              </button>
              <button
                type='button'
                className='devices-btn-secondary'
                onClick={handleReset}
                disabled={loading}
              >
                Limpiar
              </button>
            </div>
          </div>
        </form>
      </div>

      <div className='results-section'>
        <div className="connection-legend">
          <div className="legend-item">
            <span className="legend-color connected"></span>
            <span>Conectado (últimos 5 minutos)</span>
          </div>
          <div className="legend-item">
            <span className="legend-color warning"></span>
            <span>Conectado (última hora)</span>
          </div>
          <div className="legend-item">
            <span className="legend-color disconnected"></span>
            <span>Desconectado (más de 1 hora)</span>
          </div>
        </div>

        <div className='table-container'>
          <table>
            <thead>
              <tr>
                <th>Descripción</th>
                <th>Ubicación</th>
                <th>N° Serie</th>
                <th>Función</th>
                <th>Modelo</th>
                <th>Última Conexión</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr>
                  <td colSpan="6" className="loading-row">
                    <div className="loading-content">
                      <span>Cargando equipos...</span>
                      <div className="loading-spinner"></div>
                    </div>
                  </td>
                </tr>
              ) : devices.length > 0 ? (
                devices.map(device => {
                  const status = getConnectionStatus(device.lastConnectionDate);
                  return (
                    <tr key={device.serialNumber}>
                      <td>{device.description || 'Desconocido'}</td>
                      <td>{device.location || 'Desconocido'}</td>
                      <td>{device.serialNumber || 'Desconocido'}</td>
                      <td>
                        {device.function === 'ACCESO'
                          ? 'Acceso'
                          : device.function === 'ASISTENCIA' || device.function === 'HORARIO'
                            ? 'Asistencia'
                            : device.function || 'Desconocido'}
                      </td>
                      <td>{device.model || 'Desconocido'}</td>
                      <td>
                        <span className={`status-badge ${status}`}>
                          {formatDateTime(device.lastConnectionDate)}
                        </span>
                      </td>
                    </tr>
                  );
                })
              ) : (
                <tr>
                  <td colSpan="6" className="no-results">
                    {companies.length <= 1
                      ? 'No hay equipos disponibles'
                      : 'No se encontraron equipos con los filtros actuales'}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default ZKDevices;