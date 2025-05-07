import { useState, useEffect } from 'react';
import './bulkprofilesend.css';
import { toast } from 'react-toastify';
import { fetchAccessProfiles, fetchSendAccessProfiles, fetchZkCompanies } from '../../../api/zkManagementApiRequests';

const BulkProfileSend = () => {
  // ==================== ESTADOS ====================
  const [serverId, setServerId] = useState(0);
  const [company, setCompany] = useState('');
  const [profileId, setProfileId] = useState(0);
  const [companies, setCompanies] = useState([{ companyId: 0, client: ' [ Seleccione ] ' }]);
  const [loading, setLoading] = useState(false);
  const [profiles, setProfiles] = useState([{ id: 0, description: ' [ Seleccione ] ' }]);


  // Opciones de servidores
  const serverOptions = [
    { value: 0, label: '[ Seleccione ]' },
    { value: 1, label: 'Servidor 1' },
    { value: 2, label: 'Servidor 2' },
    { value: 3, label: 'Servidor 3' }
  ];

  useEffect(() => {
    if (serverId === 0) {
      setCompanies([{ companyId: 0, client: '[ Seleccione ]' }]);
      setCompany('');
      return;
    }

    setLoading(true);
    fetchZkCompanies(serverId)
      .then((response) => {
        if (response) {
          setCompanies([{ companyId: 0, client: '[ Seleccione ]' }, ...response.data]);
        }
      })
      .catch((error) => {
        if (error.code === "ERR_NETWORK") {
          toast.error("No se pudo establecer conexión con la API de gestión de equipos.");
        } else if (error.response?.data) {
          switch (error.response.data.statusCode) {
            case 400:
              toast.warning(error.response.data.message);
              break;
            case 401:
              toast.warning('Su sesión ha expirado.');
              break;
            case 500:
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
        setLoading(false)
      }
      );
  }, [serverId]);

  useEffect(() => {
    if (company === '' || company === null) {
      return;
    }

    setLoading(true);
    fetchAccessProfiles(serverId, company)
      .then(response => {
        if (response) {
          setProfiles([{ id: 0, description: '[ Seleccione ]' }, ...response.data]);
        }
      })
      .catch((error) => {
        if (error.code === "ERR_NETWORK") {
          toast.error("No se pudo establecer conexión con la API de gestión de equipos.");
        } else if (error.response?.data) {
          switch (error.response.data.statusCode) {
            case 400:
              toast.warning(error.response.data.message);
              break;
            case 401:
              toast.warning('Su sesión ha expirado.');
              break;
            case 500:
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
        setLoading(false)
      }
      );

  }, [company])

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);

    if (serverId === 0 || !company) {
      toast.warning('Seleccione servidor y empresa válidos');
      setLoading(false);
      return;
    }

    if (profileId === 0) {
      toast.warning('Seleccione un perfil válido');
      setLoading(false);
      return;
    }


    fetchSendAccessProfiles(serverId, company, profileId)
      .then(response => {
        if (response) {
          toast.success(response.message);
        }
      })
      .catch((error) => {
        if (error.code === "ERR_NETWORK") {
          toast.error("No se pudo establecer conexión con la API de gestión de equipos.");
        } else if (error.response?.data) {
          switch (error.response.data.statusCode) {
            case 400:
              toast.warning(error.response.data.message);
              break;
            case 401:
              toast.warning('Su sesión ha expirado.');
              break;
            case 500:
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
        setLoading(false)
      }
      );

  };

  const handleReset = () => {
    setServerId(0);
    setCompany('');
    setProfileId(0);
  };

  // ==================== RENDER ====================
  return (
    <div className="bulk-profile-container">
      <div className="filter-section">
        <h2 className="filter-title">Asignación Masiva de Perfiles</h2>

        <form onSubmit={handleSubmit}>
          <div className="system-config-section">
            <h3>Selección de Empresa</h3>

            <div className="filter-row">
              <div className="filter-group">
                <label>Servidor:</label>
                <select
                  value={serverId}
                  onChange={(e) => setServerId(Number(e.target.value))}
                  className="form-select"
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

              <div className="filter-group">
                <label>Empresa:</label>
                <select
                  value={company}
                  onChange={(e) => {
                    setCompany(e.target.value)
                  }
                  }
                  className="form-select"
                  required
                  disabled={loading || serverId === 0}
                >
                  {companies.map(company => (
                    <option key={company.companyId} value={company.databaseName}>
                      {company.client}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          {/* SECCIÓN 2: SELECCIÓN DE PERFIL */}
          <div className="profile-section">
            <h3>Selección de Perfil</h3>

            <div className="filter-row">
              <div className="filter-group">
                <label>Perfil a Asignar:</label>
                <select
                  value={profileId}
                  onChange={(e) => setProfileId(Number(e.target.value))}
                  className="form-select"
                  required
                  disabled={loading}
                >
                  {profiles.map(profile => (
                    <option key={profile.id} value={profile.id}>
                      {profile.description}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          {/* SECCIÓN 3: ACCIONES */}
          <div className="actions-section">
            <div className="filter-actions">
              <button
                type="submit"
                className={loading ? "btn-loading" : "btn-primary"}
                disabled={loading}
              >
                {loading ? 'Cargando...' : 'Enviar Perfiles'}
              </button>
              <button
                type="button"
                className="btn-secondary"
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

export default BulkProfileSend;