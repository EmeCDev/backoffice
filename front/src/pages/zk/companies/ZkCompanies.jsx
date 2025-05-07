import { useEffect, useState } from 'react';
import { toast } from 'react-toastify';
import axios from 'axios';
import 'react-toastify/dist/ReactToastify.css';
import './zkcompanies.css';
import { fetchZkCompanies } from '../../../api/zkManagementApiRequests';
import { useNavigate } from 'react-router-dom';
import { PUBLIC_ROUTES } from '../../../routes.js';

// Configure Axios defaults
axios.defaults.withCredentials = true;

const ZkCompanies = () => {
  const navigate = useNavigate();

  // State for filters
  const [serverId, setServerId] = useState(0);
  const [searchedServerId, setSearchedServerId] = useState(0);
  const [companyName, setCompanyName] = useState('');

  const [companies, setCompanies] = useState([]);
  const [loading, setLoading] = useState(false);

  // Server options
  const serverOptions = [
    { value: 0, label: '[ Seleccione ]' },
    { value: 1, label: 'Servidor 1' },
    { value: 2, label: 'Servidor 2' },
    { value: 3, label: 'Servidor 3' }
  ];

  useEffect(()=>{
    setCompanies([]);
  },[serverId])

  const handleSubmit = (e) => {
    e.preventDefault();
    if (loading) return;

    if (serverId == 0) {
      toast.warning("Debe seleccionar un servidor.")
      return;
    }

    setSearchedServerId(serverId);

    setLoading(true);

    fetchZkCompanies(serverId, companyName)
      .then((response) => {
        if (response) {
          toast.success(response.message);
          setCompanies(response.data);
        }
      })
      .catch((error) => {
        if (error.code === "ERR_NETWORK") {
          toast.error("No se pudo establecer conexión con la API de gestion de equipos.");
        } else if (error.response.data) {
          switch (error.response.data.statusCode) {
            case 400:
              setCompanies([]);
              toast.warning(error.response.data.message);
              break;
            case 401:
              navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, {replace: true});
              toast.warning('Su sesión ha expirado.');
              break;
            case 500:
              setCompanies([]);
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

  const handleReset = (e) => {
    e.preventDefault();
    setServerId(null);
    setCompanyName(null);
  };

  return (
    <div className='zk-companies-container'>
      <div className='filter-section'>
        <h2 className='zk-section-subtitle'>Filtros de búsqueda:</h2>
        <form onSubmit={handleSubmit}>
          <div className='filter-row'>
            <div className='filter-group'>
              <label htmlFor='ServerId'>Servidor:</label>
              <select
                id='ServerId'
                name='ServerId'
                value={serverId}
                onChange={(e) => setServerId(e.target.value)}
                className='form-select'
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
              <label htmlFor='CompanyName'>Nombre Empresa:</label>
              <input
                type='text'
                id='CompanyName'
                name='CompanyName'
                value={companyName}
                onChange={(e) => setCompanyName(e.target.value)}
                placeholder='Buscar por nombre'
                disabled={loading}
              />
            </div>

            <div className='filter-actions'>
              <button 
                type='submit' 
                className={loading ? 'btn-disabled' : 'btn-primary'}
                disabled={loading}
              >
                {loading ? 'Cargando...' : 'Buscar'}
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

      <div className='results-section'>
        {loading ? (
          <div className='loading-indicator'>Cargando compañías...</div>
        ) : (
          <div className='table-container'>
            <table>
              <thead className='sticky-header'>
                <tr>
                  <th>Servidor</th>
                  <th>ID Empresa</th>
                  <th>Nombre</th>
                  <th>Base de Datos</th>
                  <th>Fecha de Ingreso</th>
                  <th>Estado</th>
                </tr>
              </thead>
              <tbody>
                {companies.length > 0 ? (
                  companies.map(company => (
                    <tr key={company.companyId}>
                      <td>{company.serverId ?? `Servidor ${searchedServerId}`}</td>
                      <td>{company.companyId ?? 'Desconocido'}</td>
                      <td>{company.client ?? 'Desconocido'}</td>
                      <td>{company.databaseName ?? 'Desconocido'}</td>
                      <td>{company.entryDate ?? 'Desconocido'}</td>
                      <td>
                        <span className={`status-badge ${company.isActive ? 'active' : 'inactive'}`}>
                          {company.isActive ? 'Activo' : 'Inactivo'}
                        </span>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="6" className='no-results'>
                      No se encontraron empresas con los filtros actuales.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default ZkCompanies;